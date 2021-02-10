import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/movie.dart';

Future<List<Movie>> fetchMovies() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'movie_database.db'),
    // When the database is first created, create a table to store movies.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        // "CREATE TABLE movies(id INTEGER PRIMARY KEY, movie_title TEXT, result TEXT)",
        "CREATE TABLE movies(movie_title TEXT, result TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  // return database;

// A method that retrieves all the movies from the movies table.

  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Movies.
  final List<Map<String, dynamic>> maps = await db.query('movies');

  // Convert the List<Map<String, dynamic> into a List<Movie>.
  return List.generate(maps.length, (i) {
    return Movie(
      movie_title: maps[i]['movie_title'],
      result: maps[i]['result'],
    );
  });

//   List p_movies = await movies();
//   print(p_movies[0]);
}

class PreviousMoviesScreen extends StatefulWidget {
  @override
  _PreviousMoviesScreenState createState() => _PreviousMoviesScreenState();
}

class _PreviousMoviesScreenState extends State<PreviousMoviesScreen> {
  Future<List<Movie>> _movieList;

  // @override
  // void didChangeDependencies() async {
  //   // TODO: implement didChangeDependencies
  //   _movieList = await init_db();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    _movieList = fetchMovies();

    return Scaffold(
      body: Center(
        child: (_movieList == null)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<List<Movie>>(
                future: _movieList,
                // itemCount: _movieList.length,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.length != 0
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, i) => Column(
                                  children: [
                                    Material(
                                      elevation: 2,
                                      child: ListTile(
                                        title: Text(
                                          snapshot.data[i].movie_title,
                                        ),
                                        trailing: Text(
                                          snapshot.data[i].result,
                                          style:
                                              snapshot.data[i].result == "Success"
                                                  ? TextStyle(color: Colors.green)
                                                  : TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                        : Center(
                            child: Text("Empty list of movies"),
                          );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }
                  return Center(child: Text("Failed to load data."));
                }),
      ),
    );
  }
}
