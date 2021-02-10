import numpy as np
import pandas as pd
import joblib
import datetime
from flask import Flask, request, jsonify, render_template
from sklearn.preprocessing import LabelEncoder,StandardScaler
from sklearn.decomposition import PCA


model = joblib.load('models/final_model.joblib')
prediction = "null"


def chat(budget,language, duration, country, company, director_name, actor_1_name, actor_2_name, actor_3_name, release_date):
    # budget = 180000000
    # duration = 160
    # country = "United States of America"
    # director_name = "Matt Reeves"
    # actor_1_name = "Robert Pattinson"
    # actor_2_name = "Zoë Kravitz"
    # actor_3_name = "Paul Dano" 
    # release_date = 2021-10-1
    # language = "English"
    lst = [[budget,language, duration, country, company, director_name, actor_1_name, actor_2_name,
     actor_3_name, release_date]] 

    df = pd.DataFrame(lst, columns=['budget','language', 'duration', 'country', 'company','director_name', 'actor_1_name', 'actor_2_name', 'actor_3_name', 'release_date'])
    # return df

    print(df.head())

    #convert_date_time
    df['release_date'] = pd.to_datetime(df['release_date'].astype(str),errors='coerce')
    df['release_date'] = df['release_date']
    df['dayofrelease']=df['release_date'].dt.strftime('%A')
    df['monthofrelease']=df['release_date'].dt.strftime('%b')
    df.drop(columns=['release_date'], inplace = True)

    # Parse the stringified features into their corresponding python objects
    from ast import literal_eval

    # Function to convert all strings to lower case and strip names of spaces
    def clean_data(x):
        if isinstance(x, list):
            return [str.lower(i.replace(" ", "")) for i in x]
        else:
            #Check if director exists. If not, return empty string
            if isinstance(x, str):
                return str.lower(x.replace(" ", ""))
            else:
                return ''

    # vals = df.loc[:,:].values 
    # print("VALUES: ",vals)
    # pca = PCA(n_components=1)
    # X = pca.fit_transform(vals)

    features = ['actor_1_name','actor_2_name','actor_3_name','director_name','country','company','language', 'dayofrelease','monthofrelease']
    for feature in features:
        df[feature] = df[feature].apply(clean_data)
    print(df)

    #getting the prediction
    prediction = 'Success' if model.predict(df) == 1 else 'Flop'
    # prediction = model.predict(data)
    print(prediction)
    return prediction      

# def test():
# print(model.predict(lst))
# chat(200000000,"English",170,"United States of America", "Metro Productions", "Aaron Schneider", "50 Cent", "Chris Sanders","Adam Brody","2021-10-1")

    
    