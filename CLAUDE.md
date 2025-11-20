# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**CDSS (Clinical Decision Support System)** - Kasallik Bashorat Qilish Tizimi (Disease Prediction System)

A mini demo application that predicts diseases based on patient data using machine learning. This is a demonstration project and should NOT be used for actual medical decision-making.

## Tech Stack

- **Backend**: FastAPI (Python)
- **Frontend**: Vue.js 3 (CDN version), Chart.js, Nginx
- **ML Framework**: scikit-learn (RandomForestClassifier)
- **Data Processing**: pandas, numpy
- **Model Persistence**: joblib
- **DevOps**: Docker, Docker Compose (with GPU support)

## Project Structure

```
cdss/
├── backend/
│   ├── main.py           # FastAPI application with endpoints
│   ├── ml_model.py       # ML model training and prediction logic
│   ├── requirements.txt  # Python dependencies
│   ├── Dockerfile        # Backend Docker image
│   ├── .dockerignore     # Docker ignore patterns
│   ├── model.pkl        # Trained model (auto-generated)
│   └── scaler.pkl       # Feature scaler (auto-generated)
├── frontend/
│   ├── index.html       # Main UI
│   ├── app.js          # Vue.js application logic
│   ├── style.css       # Styling
│   ├── nginx.conf      # Nginx web server configuration
│   ├── Dockerfile      # Frontend Docker image
│   └── .dockerignore   # Docker ignore patterns
├── docker-compose.yml  # Docker Compose with GPU support
├── Makefile           # Automation commands
├── README.md
└── CLAUDE.md
```

## Development Setup

### Recommended: Docker Setup (Fastest & Easiest)

Docker Compose handles all dependencies and configuration automatically, including GPU support for accelerated ML inference.

**Quick Start:**
```bash
# One command to build and start everything
make install

# Or using docker-compose directly
docker-compose up -d
```

**Access Points:**
- Frontend UI: http://localhost:3000
- Backend API: http://localhost:8000
- API Documentation: http://localhost:8000/docs
- Health Check: http://localhost:8000/health

**Common Make Commands:**
```bash
make help        # Show all available commands
make build       # Build Docker images
make up          # Start all services
make down        # Stop all services
make restart     # Restart services
make logs        # View all logs
make logs-backend    # Backend logs only
make logs-frontend   # Frontend logs only
make ps          # Show running containers
make test        # Run API test
make health      # Check service health
make clean       # Remove all containers and volumes
make rebuild     # Clean rebuild
make shell-backend   # Open shell in backend container
make shell-frontend  # Open shell in frontend container
make gpu-check   # Verify GPU availability
```

**GPU Configuration:**

The project includes GPU support for NVIDIA GPUs. The `docker-compose.yml` file contains:

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all  # Use all GPUs
          capabilities: [gpu]
```

To verify GPU availability:
```bash
make gpu-check
```

To disable GPU (if not needed):
- Remove or comment out the `deploy` section in `docker-compose.yml`

**Docker Architecture:**
- Backend runs in Python container with FastAPI + ML model
- Frontend runs in Nginx container serving static files
- Nginx proxies `/api` requests to backend
- Shared network `cdss-network` for inter-container communication
- Volume `model_data` persists trained ML models

### Alternative: Manual Setup (Development)

#### Backend Setup

```bash
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the server
python main.py
```

Backend runs on: `http://localhost:8000`
API Documentation: `http://localhost:8000/docs`

#### Frontend Setup

```bash
cd frontend

# Option 1: Python HTTP server
python -m http.server 3000

# Option 2: Node.js http-server
npx http-server -p 3000
```

Frontend runs on: `http://localhost:3000`

**Note:** When running manually, the frontend expects backend at `http://localhost:8000` (hardcoded for development mode).

## API Endpoints

- `GET /` - API information and available endpoints
- `GET /health` - Health check and model status
- `POST /api/predict` - Disease prediction endpoint
- `GET /api/diseases` - List of all disease names

## ML Model Architecture

### Features (Input)
The model expects 6 features:
1. **age** - Patient age (0-120 years)
2. **blood_pressure** - Systolic blood pressure (60-200 mmHg)
3. **cholesterol** - Cholesterol level (100-400 mg/dL)
4. **glucose** - Blood glucose level (50-300 mg/dL)
5. **bmi** - Body Mass Index (10-50 kg/m²)
6. **heart_rate** - Heart rate (40-200 bpm)

### Predictions (Output)
The model predicts one of 5 conditions:
- Sog'lom (Healthy)
- Yurak kasalligi (Heart disease)
- Diabet (Diabetes)
- Gipertenziya (Hypertension)
- Astma (Asthma)

### Model Details
- **Algorithm**: RandomForestClassifier (100 estimators)
- **Preprocessing**: StandardScaler for feature normalization
- **Training**: Simulated data (1000 samples) for demo purposes
- **Persistence**: Models saved as `model.pkl` and `scaler.pkl`

## Key Classes and Functions

### Backend (`ml_model.py`)

- `DiseasePredictor` class:
  - `train_model()` - Generates demo data and trains the model
  - `load_model()` - Loads saved model or trains new one if missing
  - `predict(age, blood_pressure, cholesterol, glucose, bmi, heart_rate)` - Returns prediction with probabilities

### Backend (`main.py`)

- `PatientData` - Pydantic model for request validation
- `predict_disease(patient)` - Main prediction endpoint handler
- CORS enabled for cross-origin requests from frontend

### Frontend (`app.js`)

- `patientData` - Form data object
- `predictDisease()` - Calls API and handles response
- `renderChart()` - Creates Chart.js visualization of probabilities
- **API URL Detection**: Automatically uses nginx proxy in Docker, or `localhost:8000` in development

### Frontend (`nginx.conf`)

- Serves static files (HTML, CSS, JS)
- Proxies `/api` requests to backend service
- Enables gzip compression
- Sets security headers
- Caches static assets

## Docker Files

### `docker-compose.yml`
- Orchestrates backend and frontend services
- Configures GPU support for backend
- Sets up networking and volumes
- Includes health checks for both services
- Auto-restart policies

### `backend/Dockerfile`
- Python 3.10 slim base image
- Installs system and Python dependencies
- Includes health check endpoint
- Runs uvicorn server on port 8000

### `frontend/Dockerfile`
- Nginx Alpine base image (lightweight)
- Copies static files and nginx config
- Exposes port 80
- Includes health check

## Testing

### Test Patient Data
```json
{
  "age": 45,
  "blood_pressure": 140,
  "cholesterol": 220,
  "glucose": 120,
  "bmi": 30,
  "heart_rate": 85
}
```

### Testing Workflow

**With Docker:**
```bash
make test
# or
make health
```

**Manual:**
1. Start backend server
2. Test API endpoints at `http://localhost:8000/docs`
3. Start frontend server
4. Fill patient form and submit
5. Verify prediction results and visualization

## Important Notes

- The ML model uses **simulated training data** for demonstration purposes
- This is a **demo project** (3-4 hour build) and should NOT be used for real medical decisions
- Always consult medical professionals for actual health concerns
- Model files (`model.pkl`, `scaler.pkl`) are auto-generated on first run if missing
- GPU support is optional; the model works fine on CPU for demo purposes
- Frontend API URL automatically adapts to Docker or development environment
