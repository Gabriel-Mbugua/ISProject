import 'package:flutter/material.dart';
import 'package:movie_app/predict.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Success Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Movie Prediction'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (_futurePrediction == null)
            ? Center(child: Text("Fill in the fields to get a prediction"))
            : FutureBuilder<Predict>(
            future: _futurePrediction,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  " Movie Prediction: ${snapshot.data.result}",
                  // style: TextStyle(
                  //   color: snapshot.data.result == "Success"
                  //       ? Colors.green
                  //       : Colors.red,
                  );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              return Center(
                  child: Text("Predection failed. Null data."));
            }),
        leading: Icon(Icons.movie),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MovieDetailsInput(
                    hint: "Budget",
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                  ),
                  MovieDetailsInput(
                      hint: "Duration",
                      controller: durationController,
                      keyboardType: TextInputType.number),
                  MovieDetailsInput(
                      hint: "Country",
                      controller: countryController,
                      keyboardType: TextInputType.text),
                  MovieDetailsInput(
                      hint: "Company",
                      controller: companyController,
                      keyboardType: TextInputType.text),
                  MovieDetailsInput(
                      hint: "director_name",
                      controller: directorController,
                      keyboardType: TextInputType.text),
                  MovieDetailsInput(
                      hint: "actor_1_name",
                      controller: actor1Controller,
                      keyboardType: TextInputType.text),
                  MovieDetailsInput(
                      hint: "actor_2_name",
                      controller: actor2Controller,
                      keyboardType: TextInputType.text),
                  MovieDetailsInput(
                      hint: "actor_3_name",
                      controller: actor3Controller,
                      keyboardType: TextInputType.text),
                  MovieDetailsInput(
                      hint: "release_date",
                      controller: dateController,
                      keyboardType: TextInputType.datetime),
                  MovieDetailsInput(
                      hint: "language",
                      controller: languageController,
                      keyboardType: TextInputType.text),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 40.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Color.fromRGBO(0, 160, 227, 1))),
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
                            }
                          },
                          color: Color.fromRGBO(0, 160, 227, 1),
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
    );
  }
}

class MovieDetailsInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  MovieDetailsInput({this.hint, this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
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
