import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/predict.dart';
import 'package:movie_app/previous_movies.dart';

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
      //   elevation: 0,
      //   leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
      //     Navigator.pop(context);
      //   }),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                                      languageController.text);
                                });
                                val = (await _futurePrediction) as String;
                                insertMovie(Movie(movie_title: nameController.text, result: val));
                              }
                            },
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            child: Text('Submit', style: TextStyle(fontSize: 15)),
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
