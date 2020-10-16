import numpy as np
import joblib
from flask import Flask, request, jsonify, render_template

app = Flask(__name__)
model = joblib.load('models/RandomForest.joblib')

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict',methods=['POST'])
def predict():
    chat()
    

@app.route('/results',methods=['POST'])
def results():
    data = request.get_json(force=True)
    prediction = model.predict([np.array(list(data.values()))])

    output = prediction[0]
    return jsonify(output)   
    
if __name__ == "__main__":
    app.run(debug=True)    