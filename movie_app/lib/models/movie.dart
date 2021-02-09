import 'package:sqflite/sqflite.dart';

class Movie{
  final String result;
  final String movie_title;

  Movie({this.result, this.movie_title});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'movie_title': movie_title,
      'result': result,
    };
  }

  @override
  String toString() {
    return 'Movie{name: $movie_title, age: $result}';
  }
}