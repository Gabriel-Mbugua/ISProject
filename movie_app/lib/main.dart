import 'package:flutter/material.dart';
import 'package:movie_app/home_page.dart';
import 'package:movie_app/predict.dart';
import 'package:movie_app/previous_movies.dart';

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
        primarySwatch: Colors.purple,
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

  int _pageIndex = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("MAPUM"),
        leading: Icon(Icons.movie),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            HomeScreen(),
            PreviousMoviesScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        elevation: 0,
        // backgroundColor: Theme.of(context).primaryColor,
        // selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Predictions"),
          ),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
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
