import numpy as np
import pandas as pd
import joblib
import datetime
from flask import Flask, request, jsonify, render_template
from sklearn.preprocessing import LabelEncoder,StandardScaler
from sklearn.decomposition import PCA


model = joblib.load('models/RandomForest.joblib')
user_maps = {}
prediction = "null"


def chat(budget, duration, country, director_name, actor_1_name, actor_2_name, actor_3_name, release_date, language):
    # budget = 180000000
    # duration = 160
    # country = "United States of America"
    # director_name = "Matt Reeves"
    # actor_1_name = "Robert Pattinson"
    # actor_2_name = "Zoë Kravitz"
    # actor_3_name = "Paul Dano"
    # release_date = 2021-10-1
    # language = "English"
    lst = [[budget, duration, country, director_name, actor_1_name, actor_2_name,
     actor_3_name, release_date, language]] 

    df = pd.DataFrame(lst, columns=['budget', 'duration', 'country',
     'director_name', 'actor_1_name', 'actor_2_name', 'actor_3_name', 'release_date',
     'language'])
    print(df)
    # return df

    #convert_date_time
    df['release_date'] = pd.to_datetime(df['release_date'].astype(str),errors='coerce')
    df['dayofrelease']=df['release_date'].dt.strftime('%A')
    df.drop(columns=['release_date'], inplace = True)


    #reading user maps text files
    le_maps = ['actor_1_name','actor_2_name','actor_3_name','director_name','country', 'company']
    new_maps = []
    for feature in le_maps:  
        s = open(f'{feature}.txt', 'r', encoding="utf-8").read()
        le_map = eval(s)   
        new_maps.append(le_map)
    # print(new_maps)

    #one hot encoding 
    nominal = ['dayofrelease', 'language']
    one_hot = pd.get_dummies(df[nominal])
    df.drop(['dayofrelease','language'], axis=1, inplace=True)
    df = df.join(one_hot)    

    #assigning label encoding mapping
    ordinal = ['actor_1_name','actor_2_name','actor_3_name','director_name','country']
    
    # for feature in ordinal:
    #     for i in new_maps:
    #         for k,v in i.items():
    #             if df[feature].values[0] == k and user_maps[df[feature].values[0]] == False:
    #                 print(f"{df[feature].values[0]} in {feature}. Key: {v}")
    #                 user_maps[df[feature].values[0]] = v
    #                 df[feature] = v
    #                 break
    #             else:
    #                 continue  

    for feature in ordinal:
        if df[feature].values[0] in new_maps[0].keys():
            print(df[feature].values[0],new_maps[0][df[feature].values[0]])
            df[feature] = new_maps[0][df[feature].values[0]]
        elif df[feature].values[0] in new_maps[1].keys():
            print(df[feature].values[0],new_maps[1][df[feature].values[0]])
            df[feature] = new_maps[1][df[feature].values[0]]
        elif df[feature].values[0] in new_maps[2].keys():
            print(df[feature].values[0],new_maps[2][df[feature].values[0]])
            df[feature] = new_maps[2][df[feature].values[0]]
        elif df[feature].values[0] in new_maps[3].keys():
            print(df[feature].values[0],new_maps[3][df[feature].values[0]])
            df[feature] = new_maps[3][df[feature].values[0]]
        elif df[feature].values[0] in new_maps[4].keys():
            print(df[feature].values[0],new_maps[4][df[feature].values[0]])
            df[feature] = new_maps[4][df[feature].values[0]]
        elif df[feature].values[0] in new_maps[5].keys():
            print(df[feature].values[0],new_maps[5][df[feature].values[0]])
            df[feature] = new_maps[5][df[feature].values[0]]
        else: 
            print("Not found")      


    data = df.loc[:,:].values      
    print(data) 

    #getting the prediction
    prediction = 'Success' if model.predict(data) == 1 else 'Flop'
    # prediction = model.predict(data)
    print(prediction)
    return prediction      


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
    prediction = 'Success' if model.predict(X) == 1 else 'Flop'
    print(prediction)
    return prediction

# print(model.predict(lst))
# chat(200000000,170,"United States of America", "Aaron Schneider", "50 Cent", "Chris Sanders","Adam Brody","2021-10-1","English")

    
    