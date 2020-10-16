import numpy as np
import pandas as pd
import joblib
import datetime
from flask import Flask, request, jsonify, render_template
from sklearn.preprocessing import LabelEncoder,StandardScaler
from sklearn.decomposition import PCA


model = joblib.load('models/RandomForest.joblib')
user_maps = {}


def chat():
    # lst = [(budget, input)]
    # dic = {key: value for (key, value) in lst}
    # budget = input("Movie budget: ")
    # duration = input("Movie durtion: ")
    # country = input("Movie country: ")
    # director_name = input("Movie director: ")
    # actor_1_name = input("Movie actor_1: ")
    # actor_2_name = input("Movie actor_2: ")
    # actor_3_name = input("Movie actor_3: ")
    # release_date = input("Weekday released: ")
    # language = input("Movie language: ")
    budget = 180000000
    duration = 160
    country = "United States of America"
    director_name = "Matt Reeves"
    actor_1_name = "Robert Pattinson"
    actor_2_name = "Zoë Kravitz"
    actor_3_name = "Paul Dano"
    release_date = 2021-10-1
    language = "English"
    lst = [[budget, duration, country, director_name, actor_1_name, actor_2_name,
     actor_3_name, release_date, language]] 

    df = pd.DataFrame(lst, columns=['budget', 'duration', 'country',
     'director_name', 'actor_1_name', 'actor_2_name', 'actor_3_name', 'release_date',
     'language'])
    print(df)
    convert_date_time(df)

def convert_date_time(df):
    df['release_date'] = pd.to_datetime(df['release_date'].astype(str),errors='coerce')
    df['dayofrelease']=df['release_date'].dt.strftime('%A')
    df.drop(columns=['release_date'], inplace = True)
    # one_hot_enc(df)
    reading(df)

def reading(df):
    le_maps = ['actor_1_name','actor_2_name','actor_3_name','director_name','country', 'company']
    new_maps = []
    for feature in le_maps:  
        s = open(f'{feature}.txt', 'r', encoding="utf-8").read()
        le_map = eval(s)   
        new_maps.append(le_map)
    # print(new_maps)    
    one_hot_enc(df, new_maps)

def one_hot_enc(df,new_maps):
    nominal = ['dayofrelease', 'language']
    one_hot = pd.get_dummies(df[nominal])
    df.drop(['dayofrelease','language'], axis=1, inplace=True)
    df = df.join(one_hot)
    label_enc(df, new_maps)

def label_enc(df, new_maps):    
    ordinal = ['actor_1_name','actor_2_name','actor_3_name','director_name','country']
    
    for feature in ordinal:
        for i in new_maps:
            for k,v in i.items():
                if df[feature].values[0] == k and df[feature].values[0] not in user_maps.keys():
                    print(f"{df[feature].values[0]} in {feature}. Key: {v}")
                    user_maps[df[feature].values[0]] = v
                    df[feature] = v
                else:
                    continue  
    predict(df.loc[:,:].values)            


def stand_scaler(df):
    print(df)
    scaler = StandardScaler()
    numerical = df.columns[df.dtypes.apply(lambda c: np.issubdtype(c, np.number))]
    df[numerical] = scaler.fit_transform(df[numerical])
    # predict(df.loc[:,:].values)
    # pca_process(df)


def pca_process(df):
    vals = df.loc[:,:].values 
    print(vals)
    pca = PCA(n_components=8)
    X = pca.fit_transform(vals)
    predict(X)

def predict(X):
    prediction = 'Success' if model.predict(X) == 0 else 'Flop'
    print(prediction)

# print(model.predict(lst))
chat()

    
    