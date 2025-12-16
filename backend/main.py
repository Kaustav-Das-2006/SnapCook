# snapcook_backend/main.py
from fastapi import FastAPI, UploadFile, File
from services import generate_recipe_from_image
from schemas import RecipeResponse
import uvicorn

app = FastAPI()

@app.post("/generate", response_model=RecipeResponse)
async def generate_recipe(file: UploadFile = File(...)):
    image_bytes = await file.read()
    result = await generate_recipe_from_image(image_bytes)
    return result

if __name__ == "__main__":
    # Host 0.0.0.0 is required for Android Emulator access
    uvicorn.run(app,port=8000)