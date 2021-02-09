import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/movie.dart';

Future<Database> init_db() async {
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
        "CREATE TABLE movies(id INTEGER PRIMARY KEY, movie_title TEXT, result TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  return database;
}

// Define a function that inserts movies into the database
Future<void> insertMovie(Movie movie) async {
  // Get a reference to the database.
  final Database db = await init_db();

  // Insert the Movie into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same movie is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'movies',
    movie.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  final movie_data = Movie(
    movie_title: 'Star Wars',
    result: "Success",
  );

  await insertMovie(movie_data);
}

// A method that retrieves all the movies from the movies table.
Future<List<Movie>> movies() async {
  // Get a reference to the database.
  final Database db = await init_db();

  // Query the table for all The Movies.
  final List<Map<String, dynamic>> maps = await db.query('movies');

  // Convert the List<Map<String, dynamic> into a List<Movie>.
  return List.generate(maps.length, (i) {
    return Movie(
      movie_title: maps[i]['movie_title'],
      result: maps[i]['result'],
    );
  });

  List p_movies = await movies();
  print(p_movies[0]);
}

class PreviousMoviesScreen extends StatefulWidget {
  @override
  _PreviousMoviesScreenState createState() => _PreviousMoviesScreenState();
}

class _PreviousMoviesScreenState extends State<PreviousMoviesScreen> {
  List<Movie> movie_list;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    movie_list = await movies();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: movie_list.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
              itemCount: movie_list.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(movie_list[i].movie_title),
                subtitle: Text(movie_list[i].result),
              ),
            ),
      ),
    );
  }
}
