# """
# Create on 2023-02-06
# author : Kenny
# Description : Flutter와 Python의 Ai의 예측값 보내기
# """

from flask import Flask, jsonify, render_template, request, Blueprint, send_file
import joblib
from werkzeug.utils import secure_filename
import numpy as np
from PIL import Image
import os
from tensorflow import keras

app = Flask(__name__)

@app.route('/createUserModel', methods=['POST'])
def upload_image():

    dir_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'save_image')

    f = request.files['image'] # 파일 받기
    f.save(dir_path + "/" + secure_filename(f.filename))
    
    return jsonify(success=True)

@app.route('/predict')
def predict():
    ws = os.path.join(os.path.dirname(os.path.abspath(__file__)), './best-wallet-cnn-model.h5')
    dir_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'save_image')
    img = Image.open(dir_path + "/image.jpg").convert('RGB').resize((128,128))
    # os.remove(wsImg)
    
    number_of_data = 1  # 데이터 수
    img_width_size = 128  # 이미지의 사이즈 , 너비
    img_height_size = 128  # 이미지의 사이즈 , 높이
    channel = 3

    testImage = np.zeros(number_of_data*img_width_size*img_height_size*channel, dtype=np.int32).reshape(number_of_data, img_height_size, img_width_size, channel) 
    
    img = np.array(img, dtype=np.int32)
    testImage[0,:,:] = img

    # Names
    dirNames = ['0', '0', '1', '1']
    os.chdir('..')
    model2 = keras.models.load_model(ws, compile=False)
    preds = model2.predict(testImage[0:1])
    
    if np.argmax(preds) == 0 :
        if (preds[0][1].astype(int) <= 2.089815e-08) | (preds[0][1].astype(int) >= 3.6183077e-31) | (preds[0][2].astype(int) <= 1.7100547e-12) | (preds[0][2].astype(int) >= 1.5536606e-28) | (preds[0][3].astype(int) <= 4.360968e-08) | (preds[0][3].astype(int) >= 6.303063e-19) :
            return jsonify({'result' : dirNames[np.argmax(preds[0])]})
    if np.argmax(preds) == 1 :
        if (preds[0][0].astype(int) <= 5.813307e-07) | (preds[0][0].astype(int) >= 1.984694e-19) | (preds[0][2].astype(int) <= 1.4295485e-08) | (preds[0][2].astype(int) >= 1.760109e-16) | (preds[0][3].astype(int) <= 1.1363751e-08) | (preds[0][3].astype(int) >= 1.0850611e-19) :
            return jsonify({'result' : dirNames[np.argmax(preds[0])]})
    if np.argmax(preds) == 2 :
        if (preds[0][0].astype(int) <= 3.0617506e-10) | (preds[0][0].astype(int) >= 0.0) | (preds[0][1].astype(int) <= 2.0255304e-05) | (preds[0][1].astype(int) >= 3.632197e-36) | (preds[0][3].astype(int) <= 2.0484667e-07) | (preds[0][3].astype(int) >= 1.7372298e-30) :
            return jsonify({'result' : dirNames[np.argmax(preds[0])]})
    if np.argmax(preds) == 3 :
        if (preds[0][0].astype(int) <= 1.2646295e-07) | (preds[0][0].astype(int) >= 1.3325831e-33) | (preds[0][1].astype(int) <= 0.35806993) | (preds[0][1].astype(int) >= 0.0) | (preds[0][2].astype(int) <= 2.3733028e-05) | (preds[0][2].astype(int) >= 2.5844624e-35) :
            return jsonify({'result' : dirNames[np.argmax(preds[0])]})
    return jsonify({'result' : '에러다 이놈아'})
            
if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)
