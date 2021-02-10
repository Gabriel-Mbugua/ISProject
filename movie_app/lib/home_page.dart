import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/predict.dart';
import 'package:movie_app/previous_movies.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Define a function that inserts movies into the database

Future<void> insertMovie(Movie movie) async {
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

  // Get a reference to the database.
  final Database db = await database;

  // Insert the Movie into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same movie is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'movies',
    movie.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  print(movie);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  final durationController = TextEditingController();
  final companyController = TextEditingController();
  final countryController = TextEditingController();
  final directorController = TextEditingController();
  final actor1Controller = TextEditingController();
  final actor2Controller = TextEditingController();
  final actor3Controller = TextEditingController();
  final dateController = TextEditingController();
  final languageController = TextEditingController();

  Future<Predict> _futurePrediction;
  String val;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: (_futurePrediction == null)
      //       ? Center(child: Text(""))
      //       : FutureBuilder<Predict>(
      //       future: _futurePrediction,
      //       builder: (context, snapshot) {
      //         if (snapshot.hasData) {
      //           val = snapshot.data.result;
      //           return Text(
      //             " Movie Prediction: ${snapshot.data.result}",
      //             // style: TextStyle(
      //             //   color: snapshot.data.result == "Success"
      //             //       ? Colors.green
      //             //       : Colors.red,
      //           );
      //         } else if (snapshot.hasError) {
      //           return Center(child: Text("${snapshot.error}"));
      //         }
      //         return Center(child: Text("Predection failed. Null data."));
      //       }),
      //   leading: Icon(Icons.movie),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, right: 15.0, bottom: 0.0, left: 15.0),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MovieDetailsInput(
                      hint: "Name",
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      icon: Icon(
                        Icons.text_fields,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "Budget",
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      icon: Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "Duration",
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      icon: Icon(
                        Icons.timelapse,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "Country",
                      controller: countryController,
                      keyboardType: TextInputType.text,
                      icon: Icon(
                        Icons.flag,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "Company",
                      controller: companyController,
                      keyboardType: TextInputType.text,
                      icon: Icon(
                        Icons.business_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "director_name",
                      controller: directorController,
                      keyboardType: TextInputType.text,
                      icon: Icon(
                        Icons.person_search_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "actor_1_name",
                      controller: actor1Controller,
                      keyboardType: TextInputType.text,
                      icon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "actor_2_name",
                      controller: actor2Controller,
                      keyboardType: TextInputType.text,
                      icon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "actor_3_name",
                      controller: actor3Controller,
                      keyboardType: TextInputType.text,
                      icon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "release_date",
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      icon: Icon(
                        Icons.date_range,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    MovieDetailsInput(
                      hint: "language",
                      controller: languageController,
                      keyboardType: TextInputType.text,
                      icon: Icon(
                        Icons.language,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            onPressed: () async {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState.validate()) {
                                print("Submit button pressed");
                                setState(() {
                                  _futurePrediction = getPrediction(
                                          int.parse(budgetController.text),
                                          int.parse(durationController.text),
                                          countryController.text,
                                          companyController.text,
                                          directorController.text,
                                          actor1Controller.text,
                                          actor2Controller.text,
                                          actor3Controller.text,
                                          dateController.text,
                                          languageController.text)
                                      .then((value) async {
                                    print('inserting');
                                    await insertMovie(Movie(
                                        movie_title: nameController.text,
                                        result: value.result));
                                    print(value.result);

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _resultPopup(
                                              context,
                                              nameController.text,
                                              value.result),
                                    );
                                  });
                                });
                              }
                            },
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            child:
                                Text('Submit', style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultPopup(BuildContext context, String movie_name, String result) {
    return new AlertDialog(
      title: Text('$movie_name Prediction'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (result == null)
              ? Text("Prediction failed!")
              : Text(
                  result,
                  style: result == "Success"
                      ? TextStyle(color: Colors.green)
                      : TextStyle(color: Colors.red),
                ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class MovieDetailsInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget icon;

  MovieDetailsInput({this.hint, this.controller, this.keyboardType, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hint,
          icon: icon,
          border: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(25),
              ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          fillColor: Colors.orangeAccent,
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}
