import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Predict> getPrediction(int budget, int duration, String country,
    String company, String director_name, String actor_1_name,
    String actor_2_name, String actor_3_name, String release_date,
    String language) async {
  final url = "http://192.168.0.108:5000/predict";
  print("getPredictionRunning");

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*/*',
      'Access-Control-Allow-Credentials': 'true'
    },
    body: jsonEncode(<String, dynamic>{
      'budget': budget,
      'duration': duration,
      'country': country,
      'company': company,
      'director_name': director_name,
      'actor_1_name': actor_1_name,
      'actor_2_name': actor_2_name,
      'actor_3_name': actor_3_name,
      'release_date': release_date,
      'language': language
    }),
  );
  print("post request run");

  if (response.statusCode != 400) {
    print("Success: " + response.body);
    print(Predict.fromJson(jsonDecode(response.body)));
    return Predict.fromJson(jsonDecode(response.body));
  } else {
    print("ERRROOOORRRR: " + "Failed to get prediction" +
        response.statusCode.toString());
    throw Exception('Failed to get prediction');
  }
}

// Future<Predict> getPrediction(
//     int budget,
//     int duration,
//     String country,
//     String company,
//     String director_name,
//     String actor_1_name,
//     String actor_2_name,
//     String actor_3_name,
//     String release_date,
//     String language) async {
//   var headers = {
//     'Content-Type': 'application/json',
//     'Access-Control-Allow-Origin': '*/*',
//     'Access-Control-Allow-Credentials': 'true'
//   };
//   var request = http.Request('POST', Uri.parse('http://192.168.0.108:5000/predict'));
//   request.body =
//       '''{\r\n    "budget": $budget,\r\n    "duration": $duration,\r\n    "country": $country,\r\n    "company": $company,\r\n    "director_name": $director_name,\r\n    "actor_1_name": $actor_1_name,\r\n    "actor_2_name": $actor_2_name,\r\n    $actor_3_name: "Paul Dano",\r\n    "release_date": $release_date,\r\n    "language": $language\r\n}''';
//   request.headers.addAll(headers);
//
//   http.StreamedResponse response = await request.send();
//
//   if (response.statusCode == 200) {
//     print(await response.stream.bytesToString());
//   } else {
//     print(response.reasonPhrase);
//   }
// }

//
// class Predict {
//   final String prediction;
//
//   Predict({
//     this.prediction
//   });
//
//   factory Predict.fromJson(String json) {
//     return Predict(
//         prediction: json['prediction']);
//   }

class Predict {
  // final int budget;
  // final int duration;
  // final String country;
  // final String company;
  // final String director_name;
  // final String actor_1_name;
  // final String actor_2_name;
  // final String actor_3_name;
  // final String release_date;
  // final String language;
  final String result;

  // final url = "http://127.0.0.1:5000/predict";
  // var headers = {
  //   'Access-Control-Allow-Credentials': 'true',
  //   'Access-Control-Allow-Origin': '*/*'
  // };

  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  // Predict(
  //     {this.budget,
  //     this.duration,
  //     this.country,
  //     this.company,
  //     this.director_name,
  //     this.actor_1_name,
  //     this.actor_2_name,
  //     this.actor_3_name,
  //     this.release_date,
  //     this.language});
  Predict({this.result});



  factory Predict.fromJson(Map<String, dynamic> json){
    return Predict(
      result: json['result']
    );
  }

  // factory Predict.fromJson(Map<String, dynamic> json) {
  //   return Predict(
  //       budget: json['budget'],
  //       duration: json['duration'],
  //       country: json['country'],
  //       company: json['company'],
  //       director_name: json['director_name'],
  //       actor_1_name: json['actor_1_name'],
  //       actor_2_name: json['actor_2_name'],
  //       actor_3_name: json['actor_3_name'],
  //       release_date: json['release_date'],
  //       language: json['language']);
  // }
}
