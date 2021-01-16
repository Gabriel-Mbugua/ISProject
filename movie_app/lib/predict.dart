import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Predict {
  final int budget;
  final int duration;
  final String country;
  final String director_name;
  final String actor_1_name;
  final String actor_2_name;
  final String actor_3_name;
  final String release_date;
  final String language;

  final url = "http://127.0.0.1:5000/predict";
  var headers = {
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Origin': '*/*'
  };

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Predict(
      {this.budget,
      this.duration,
      this.country,
      this.director_name,
      this.actor_1_name,
      this.actor_2_name,
      this.actor_3_name,
      this.release_date,
      this.language});

  factory Predict.fromJson(Map<String, dynamic> json) {
    return Predict(
        budget: json['budget'],
        duration: json['duration'],
        country: json['country'],
        director_name: json['director_name'],
        actor_1_name: json['actor_1_name'],
        actor_2_name: json['actor_2_name'],
        actor_3_name: json['actor_3_name'],
        release_date: json['release_date'],
        language: json['language']);
  }

  Future<String> prediction() async {
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*/*'
        },
        body: json.encode({
          'budget': budget,
          'duration': duration,
          'country': country,
          'director_name': director_name,
          'actor_1_name': actor_1_name,
          'actor_2_name': actor_2_name,
          'actor_3_name': actor_3_name,
          'release_date': release_date,
          'language': language
        }),
      );
      print(response.body);
      return response.body;
    } catch (e) {
      print("Error with prediction call: $e");
    }
  }
}
