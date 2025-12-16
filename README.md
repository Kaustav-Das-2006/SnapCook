# 🍳 SnapCook

![Status](https://img.shields.io/badge/status-development-orange) ![License](https://img.shields.io/badge/license-MIT-blue)

## 📖 Overview

**SnapCook** is a smart mobile application designed to help users minimize food waste and decide what to cook instantly. Users can simply snap a picture of the ingredients they have at home, and the app uses AI to generate delicious recipe ideas based on those specific items.

## ✨ Key Features

* **📸 Ingredient Recognition:** Capture images of ingredients directly through the app.
* **🤖 AI-Powered Recipes:** Generates unique recipes using GenAI based on the detected ingredients.
* **📱 Cross-Platform:** Built with Flutter for a smooth experience on Android.
* **⚡ Fast Backend:** Powered by a high-performance FastAPI server.

## 🛠️ Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend:** Python (FastAPI)
* **AI/ML:** [Mention the specific AI API you are using, e.g., OpenAI API / Gemini API / Custom Model]
* **Database:** [e.g., SQLite / PostgreSQL]

## 📸 Screenshots

| Ingredient Capture | Recipe Generation |
|:---:|:---:|
| <img src="assets/screen1.png" width="250"> | <img src="assets/screen2.png" width="250"> |

## 🚀 Getting Started

### Prerequisites
* Flutter SDK
* Python 3.10+
* An API Key for the AI service

### Installation

**1. Backend Setup (FastAPI)**
```bash
# Navigate to the backend folder
cd backend

# Create a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn main:app --reload
2. Frontend Setup (Flutter)

Bash

# Navigate to the app folder
cd frontend

# Get packages
flutter pub get

# Run the app
flutter run
🤝 Contributing
Contributions are welcome! If you have ideas for better prompt engineering or UI improvements, feel free to open a Pull Request.
