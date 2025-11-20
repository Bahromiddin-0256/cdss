import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler
import joblib
import os

class DiseasePredictor:
    def __init__(self):
        self.model = None
        self.scaler = None
        self.disease_names = [
            "Sog'lom",
            "Yurak kasalligi",
            "Diabet",
            "Gipertenziya",
            "Astma"
        ]

    def train_model(self):
        """Demo uchun oddiy model o'rgatish"""
        # Simulyatsiya qilingan trening ma'lumotlari
        np.random.seed(42)
        n_samples = 1000

        # Features: age, blood_pressure, cholesterol, glucose, bmi, heart_rate
        X = np.random.randn(n_samples, 6)
        X[:, 0] = X[:, 0] * 15 + 50  # Yosh: 35-65
        X[:, 1] = X[:, 1] * 20 + 120  # Qon bosimi: 100-140
        X[:, 2] = X[:, 2] * 40 + 180  # Xolesterin: 140-220
        X[:, 3] = X[:, 3] * 30 + 100  # Glyukoza: 70-130
        X[:, 4] = X[:, 4] * 5 + 25    # BMI: 20-30
        X[:, 5] = X[:, 5] * 15 + 75   # Yurak urishi: 60-90

        # Labels
        y = np.random.randint(0, 5, n_samples)

        # Scaler
        self.scaler = StandardScaler()
        X_scaled = self.scaler.fit_transform(X)

        # Model
        self.model = RandomForestClassifier(n_estimators=100, random_state=42)
        self.model.fit(X_scaled, y)

        # Saqlash
        joblib.dump(self.model, 'model.pkl')
        joblib.dump(self.scaler, 'scaler.pkl')

        print("✅ Model muvaffaqiyatli o'rgatildi!")

    def load_model(self):
        """Saqlangan modelni yuklash"""
        if os.path.exists('model.pkl') and os.path.exists('scaler.pkl'):
            self.model = joblib.load('model.pkl')
            self.scaler = joblib.load('scaler.pkl')
            print("✅ Model yuklandi!")
        else:
            print("⚠️ Model topilmadi. Yangi model o'rgatilmoqda...")
            self.train_model()

    def predict(self, age, blood_pressure, cholesterol, glucose, bmi, heart_rate):
        """Bashorat qilish"""
        if self.model is None:
            self.load_model()

        # Ma'lumotlarni tayyorlash
        features = np.array([[age, blood_pressure, cholesterol, glucose, bmi, heart_rate]])
        features_scaled = self.scaler.transform(features)

        # Bashorat
        prediction = self.model.predict(features_scaled)[0]
        probabilities = self.model.predict_proba(features_scaled)[0]

        # Natijalar
        results = {
            "prediction": self.disease_names[prediction],
            "confidence": float(probabilities[prediction] * 100),
            "all_probabilities": {
                disease: float(prob * 100)
                for disease, prob in zip(self.disease_names, probabilities)
            }
        }

        return results
