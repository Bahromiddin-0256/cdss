from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from ml_model import DiseasePredictor
from typing import Dict

app = FastAPI(title="CDSS Mini API", version="1.0.0")

# CORS sozlamalari
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ML model
predictor = DiseasePredictor()
predictor.load_model()

# Request schema
class PatientData(BaseModel):
    age: int = Field(..., ge=0, le=120, description="Yosh")
    blood_pressure: float = Field(..., ge=60, le=200, description="Qon bosimi (sistolic)")
    cholesterol: float = Field(..., ge=100, le=400, description="Xolesterin (mg/dL)")
    glucose: float = Field(..., ge=50, le=300, description="Qon shakar (mg/dL)")
    bmi: float = Field(..., ge=10, le=50, description="BMI")
    heart_rate: int = Field(..., ge=40, le=200, description="Yurak urish tezligi")

    class Config:
        json_schema_extra = {
            "example": {
                "age": 45,
                "blood_pressure": 130,
                "cholesterol": 200,
                "glucose": 110,
                "bmi": 28.5,
                "heart_rate": 75
            }
        }

@app.get("/")
async def root():
    return {
        "message": "CDSS Mini API",
        "version": "1.0.0",
        "endpoints": {
            "health": "/health",
            "predict": "/api/predict",
            "docs": "/docs"
        }
    }

@app.get("/health")
async def health_check():
    return {"status": "ok", "model_loaded": predictor.model is not None}

@app.post("/api/predict")
async def predict_disease(patient: PatientData) -> Dict:
    """
    Bemorning ma'lumotlari asosida kasallik bashorati
    """
    try:
        result = predictor.predict(
            age=patient.age,
            blood_pressure=patient.blood_pressure,
            cholesterol=patient.cholesterol,
            glucose=patient.glucose,
            bmi=patient.bmi,
            heart_rate=patient.heart_rate
        )

        return {
            "success": True,
            "data": result,
            "patient_info": patient.dict()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/diseases")
async def get_diseases():
    """Barcha kasalliklar ro'yxati"""
    return {
        "diseases": predictor.disease_names
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
