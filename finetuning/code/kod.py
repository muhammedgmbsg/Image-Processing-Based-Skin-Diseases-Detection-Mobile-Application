# -*- coding: utf-8 -*-
"""Colab'e hoş geldiniz. adlı not defterinin kopyası

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1W8NvfhNXcqDGmZqu-NQDeuvCo2pcCsJs

# Yeni Bölüm
"""

# Hücrenin en başına koyun:
!pip install --upgrade tensorflow==2.18.0 \
    tensorflow-decision-forests==1.11.0 \
    tf-keras==2.18.0 \
    tensorflow-text==2.18.1

from google.colab import drive
drive.mount('/content/drive', force_remount=True)

# 1. Gerekli kütüphaneler
import os
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from tensorflow.keras.preprocessing.image import load_img, img_to_array, ImageDataGenerator
from tensorflow.keras.utils import to_categorical
import matplotlib.pyplot as plt
from tensorflow.keras import Input
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint

image_dir = '/content/drive/MyDrive/outputDirectory'
img_size    = (224, 224)
batch_size  = 32
random_seed = 42

# 3. Görüntüleri ve (string) etiketleri topla
images = []
labels = []
for fname in os.listdir(image_dir):
    if fname.lower().endswith(('.jpg', '.jpeg', '.png')):
        arr = img_to_array(load_img(os.path.join(image_dir, fname), target_size=img_size))
        images.append(arr)
        labels.append("sağlıklı" if '_healthy_' in fname.lower() else "sağlıksız")

# 4. NumPy dizilerine dönüştür ve ölçeklendir
X = np.array(images, dtype='float32') / 255.0
y_str = np.array(labels)

# 5. String etiketleri sayısala çevir
le    = LabelEncoder()
y_num = le.fit_transform(y_str)   # örn: 0 = sağlıklı, 1 = sağlıksız

# 5.1. Etiket dağılımını matplotlib ile görselleştirme
unique, counts = np.unique(y_num, return_counts=True)
plt.figure(figsize=(6,4))
plt.bar(unique, counts, tick_label=le.classes_)
plt.title('Veri Kümesindeki Etiket Dağılımı')
plt.xlabel('Etiketler')
plt.ylabel('Örnek Sayısı')
plt.show()

# 6. Eğitim / validasyon / test kümesi ayır
X_train, X_temp, y_train_num, y_temp_num = train_test_split(
    X, y_num,
    test_size=0.30,
    stratify=y_num,
    random_state=random_seed
)
X_val, X_test, y_val_num, y_test_num = train_test_split(
    X_temp, y_temp_num,
    test_size=0.50,
    stratify=y_temp_num,
    random_state=random_seed
)

# 7. One-hot encoding
y_train = to_categorical(y_train_num)
y_val   = to_categorical(y_val_num)
y_test  = to_categorical(y_test_num)

# 8. DataGenerator’lar
train_datagen = ImageDataGenerator(
    rotation_range=10,
    zoom_range=0.2,
    shear_range=0.2,
    horizontal_flip=True
)
test_datagen = ImageDataGenerator()

train_gen = train_datagen.flow(X_train, y_train, batch_size=batch_size, shuffle=True)
val_gen   = test_datagen.flow(X_val,   y_val,   batch_size=batch_size, shuffle=False)
test_gen  = test_datagen.flow(X_test,  y_test,  batch_size=batch_size, shuffle=False)

# 9. Kısaca küme boyutlarını yazdır
print(f"Train:      {X_train.shape[0]} örnek")
print(f"Validation: {X_val.shape[0]} örnek")
print(f"Test:       {X_test.shape[0]} örnek")

model = Sequential([
    # 1) İlk katman olarak açıkça bir Input tanımlıyoruz
    Input(shape=(*img_size, 3)),

    # 2) Ardından konvolüsyon ve havuzlama katmanları
    Conv2D(32, (3,3), activation='relu'),
    MaxPooling2D(),

    Conv2D(64, (3,3), activation='relu'),
    MaxPooling2D(),

    # 3) Çıkışı düzleştirip tam bağlı katmanlara geçiyoruz
    Flatten(),
    Dense(128, activation='relu'),
    Dropout(0.5),

    # 4) Son sınıflandırma katmanı
    Dense(2, activation='softmax')
])

model.compile(
    optimizer='adam',
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

model.summary()

# 1) Callback’leri oluştur
es = EarlyStopping(
    monitor='val_loss',
    patience=3,
    restore_best_weights=True
)
mc = ModelCheckpoint(
    'best_model.h5',
    monitor='val_accuracy',
    save_best_only=True
)

# 2) Eğitime başla
history = model.fit(
    train_gen,
    epochs=20,
    validation_data=val_gen,
    callbacks=[es, mc]
)

from tensorflow.keras.models import load_model
best = load_model('best_model.h5')

# Test kümesinde performans ölçümü
loss, acc = best.evaluate(test_gen)
print(f"Test Loss: {loss:.4f}, Test Accuracy: {acc:.2%}")

import matplotlib.pyplot as plt

plt.figure(figsize=(12,4))
plt.subplot(1,2,1)
plt.plot(history.history['accuracy'], label='train_acc')
plt.plot(history.history['val_accuracy'], label='val_acc')
plt.legend(); plt.title('Doğruluk')

plt.subplot(1,2,2)
plt.plot(history.history['loss'], label='train_loss')
plt.plot(history.history['val_loss'], label='val_loss')
plt.legend(); plt.title('Kayıp')
plt.show()

from google.colab import files
files.download('best_model.h5')

import tensorflow as tf
from google.colab import files

model = tf.keras.models.load_model('best_model.h5')

converter = tf.lite.TFLiteConverter.from_keras_model(model)


tflite_model = converter.convert()

# 4) .tflite dosyası olarak kaydet
with open('model.tflite', 'wb') as f:
    f.write(tflite_model)

# 5) İndir
files.download('model.tflite')

