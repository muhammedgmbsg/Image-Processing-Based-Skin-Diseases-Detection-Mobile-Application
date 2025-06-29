## Repository Notes

1. **Notebook & Model Files:** Jupyter notebook (`.ipynb`) and the trained TFLite model (`skin_model.tflite`) live in the root.  
2. **Mobile App Source:** Flutter code for iOS & Android under `lib/`, including UI, image processing and TFLite integration.  
3. **Server & API:** Python Flask backend in `server/` folder handles image uploads, runs the Keras model and returns JSON predictions.  
4. **Assets:** All icons, example images and the TFLite file are in `assets/`.  
5. **Documentation:** API spec, project report and presentation slides in `docs/`.  
6. **Results & Demo:** Screenshots and sample console logs in `results/`.

---

## Project Introduction

This end-to-end project uses a CNN to classify **10 different skin conditions** on-device.  
A Flutter app lets users pick or capture a skin photo, crops & preprocesses it, then performs a fast inference via TFLite.  
Probabilities for each condition are displayed, and the top prediction is highlighted.

---

##Label	Advice
Eczema	“Eczema is a chronic inflammatory condition characterized by itching, redness and scaling. Use barrier‐strengthening moisturizers and topical treatments. Watch out for stress and temperature triggers.”
Warts Molluscum and other Viral Infections	“Viral infections like warts and molluscum cause raised, itchy lesions. Immune‐boosting therapies and local cryotherapy are recommended.”
Melanoma	“Melanoma is the most aggressive skin cancer and requires immediate dermatological evaluation. Look out for asymmetry, color changes, or rapid growth.”
Atopic Dermatitis	“Often starting in childhood, atopic dermatitis is a chronic itchy condition. Emollients, soothing baths, and topical corticosteroids may be used.”
Basal Cell Carcinoma (BCC)	“BCC is the most common, slow‐growing skin cancer. Surgical excision, cryotherapy or topical treatments are effective.”
Melanocytic Nevi (NV)	“Commonly benign moles; monitor for any changes in size, shape or color and consult a dermatologist if noted.”
Benign Keratosis-like Lesions (BKL)	“Age‐related, rough, benign skin growths. Can be removed for cosmetic reasons via cryotherapy or laser.”
Psoriasis pictures Lichen Planus and related diseases	“Chronic inflammatory lesions like psoriasis and lichen planus may need topical treatments, phototherapy or systemic drugs.”
Seborrheic Keratoses and other Benign Tumors	“Benign growths often in middle age. Cryotherapy can remove lesions if symptomatic or for appearance.”
Tinea Ringworm Candidiasis and other Fungal Infections	“Fungal infections present with itchy ring‐shaped rashes. Apply antifungal creams and maintain good hygiene.”

## Features

1. **10-class Multiclass Classification**  
2. **Offline Inference** via TFLite for low latency  
3. **Intuitive UI** for image selection, cropping & analysis  
4. **Full Probability Breakdown** for all 10 conditions  
5. **Cross-Platform**: Android & iOS support  

---

## App Video


https://github.com/user-attachments/assets/e0ed673a-8903-4293-a1cb-c6e07d1310dc




## Usage

### Prerequisites

- Flutter SDK ≥ 2.10  
- Python 3.8+ & Flask  
- A real device for camera access  

### Installation & Run

```bash
# Clone the repo
git clone <REPO_URL>
cd <PROJECT_DIR>

# Backend setup
cd server
python -m venv venv
venv\Scripts\activate       # Windows
pip install -r requirements.txt
flask run                  # starts http://localhost:5000

# Mobile app setup
cd ../
flutter pub get
flutter run                # choose Android or iOS device
