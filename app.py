import requests
from flask import Flask, jsonify, request
from flask_cors import CORS
from model import chat

app = Flask(__name__)
CORS(app)


@app.route('/predict', methods=['POST'])
def prediction():
    budget = request.json['budget']
    duration = request.json['duration']
    country = request.json['country']
    company = request.json['company']
    director_name = request.json['director_name']
    actor_1_name = request.json['actor_1_name']
    actor_2_name = request.json['actor_2_name']
    actor_3_name = request.json['actor_3_name']
    release_date = request.json['release_date']
    language = request.json['language']

    movie_details = {
        'budget': budget,
        'duration': duration,
        'country': country,
        'company' : company,
        'director_name': director_name,
        'actor_1_name': actor_1_name,
        'actor_2_name': actor_2_name,
        'actor_3_name': actor_3_name,
        'release_date': release_date,
        'language': language
    }

    test = chat(budget,  duration, country, company, director_name, actor_1_name,
                actor_2_name, actor_3_name, release_date, language)
    return jsonify(test)
    # return jsonify({'prediction' : chat(movie_details['budget'], movie_details['duration'], movie_details['country'], movie_details['director_name'], movie_details['actor_1_name']
    # ,movie_details['actor_2_name'], movie_details['actor_3_name'], movie_details['release_date'] ,movie_details['language'])})


@app.route('/movies')
def get_movie_details():
    headers = { 
        'x-rapidapi-key': '55a3282ad4mshdd0d71e8779f2e0p16bfffjsn8cca26caf46a',
        'x-rapidapi-host': 'movies-tvshows-data-imdb.p.rapidapi.com'
    }
    id = request.json['id']
    url = f"https://movies-tvshows-data-imdb.p.rapidapi.com/?type=get-movie-details&imdb={id}"
    response = requests.request("GET", url, headers=headers)
    print(response.text)


app.run(debug=True)
