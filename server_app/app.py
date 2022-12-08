import json
from flask import Flask, request
import os
from PIL import Image
from mtcnn.mtcnn import MTCNN
import numpy as np
import tensorflow as tf
from tensorflow import keras

app = Flask(__name__)

gender_dict = {0:"Male",1:"Female"}
race_dict = {0:"White",1:"Black",2:"Asian",3:"Indian",4:"Other"}

# load the model
model = tf.keras.models.load_model('model_inceptionv3_part4.h5')

def extract_face(image, required_size=(200, 200)):
    image = image.convert('RGB')
    pixels = np.asarray(image)
    detector = MTCNN()
    results = detector.detect_faces(pixels)
    x1, y1, width, height = results[0]['box']
    x1, y1 = abs(x1), abs(y1)
    x2, y2 = x1 + width, y1 + height
    face = pixels[y1:y2, x1:x2]
    image = Image.fromarray(face)
    image = image.resize(required_size)
    face_array = np.asarray(image)
    face_array = face_array.astype("float32")
    return face_array

@app.route('/')
def home():
    return json.dumps({'status':'Welcome to artificial incoherence API'})

@app.route('/predictions/', methods=['POST'], strict_slashes=False)
def predict():
    if 'image' not in request.files:
        return json.dumps({'Age': 'Error', 'Gender': 'Error', 'Race': 'Error'})
    rfile = request.files['image']
    image = Image.open(rfile).resize((200, 200))
    output1 = extract_face(image, required_size=(200, 200))
    output1 = output1 / 255
    output1_reshaped = output1.reshape(-1,200,200,3)
    output2 = model.predict(output1_reshaped)
    
    pred_age = output2[0].round()
    pred_gender = output2[1]
    pred_gender = pred_gender.round()
    pred_race = output2[2]
    pred_race = (pred_race == pred_race.max(axis=1, keepdims=1)).astype(float)
    pred_race = [int(np.where(pred_race[i] == 1)[0]) for i in range(len(pred_race))]
    pred_age = pred_age[0][0]
    pred_gender = pred_gender[0][0]
    pred_race = pred_race[0]
    return json.dumps({'Age': f"{pred_age}", 'Gender': f"{gender_dict[pred_gender]}", 'Race': f"{race_dict[pred_race]}"})


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, host='0.0.0.0', port=port)