from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array
import numpy as np
import os

app = Flask(__name__)
model = load_model("skin_model.h5")  # Model dosyasını aynı klasöre koy

class_names = [
    'Eczema',
    'Warts Molluscum and other Viral Infections',
    'Melanoma',
    'Atopic Dermatitis',
    'Basal Cell Carcinoma (BCC)',
    'Melanocytic Nevi (NV)',
    'Benign Keratosis-like Lesions (BKL)',
    'Psoriasis pictures Lichen Planus and related diseases',
    'Seborrheic Keratoses and other Benign Tumors',
    'Tinea Ringworm Candidiasis and other Fungal Infections',
]

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({"error": "Dosya gönderilmedi"}), 400

    file = request.files['file']
    file.save("temp.jpg")

    image = load_img("temp.jpg", target_size=(224, 224))
    img_array = img_to_array(image) / 255.0
    img_array = np.expand_dims(img_array, axis=0)

    preds = model.predict(img_array)[0]

    print("Model tahmini (çıktı):", preds)
    print("Çıktı boyutu:", len(preds))

    predicted_class = class_names[np.argmax(preds)]
    confidence = round(float(np.max(preds)) * 100, 2)

    return jsonify({"class": predicted_class, "confidence": confidence})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8000)
