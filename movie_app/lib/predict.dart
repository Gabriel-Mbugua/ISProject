import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Predict> getPrediction(int budget, int duration, String country,
    String company, String director_name, String actor_1_name,
    String actor_2_name, String actor_3_name, String release_date,
    String language) async {
  final url = "http://192.168.0.108:5000/predict";

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

  if (response.statusCode != 400) {
    // print("Success: " + response.body);
    // print(Predict.fromJson(jsonDecode(response.body)));
    return Predict.fromJson(jsonDecode(response.body));
  } else {
    // print("ERRROOOORRRR: " + "Failed to get prediction" +
    //     response.statusCode.toString());
    throw Exception('Failed to get prediction');
  }
}


class Predict {
  final String result;

  Predict({this.result});



  factory Predict.fromJson(Map<String, dynamic> json){
    return Predict(
      result: json['result']
    );
  }

}
