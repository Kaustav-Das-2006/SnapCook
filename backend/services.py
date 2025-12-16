# snapcook_backend/services.py
import google.generativeai as genai
import json
import os

# --- 🔑 PASTE YOUR API KEY BELOW ---
os.environ["GOOGLE_API_KEY"] = "AIzaSyDFXBoMxYJi7xOfFBSZI3ba5bZrINnnUqw"
# -----------------------------------

genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
model = genai.GenerativeModel('models/gemini-2.5-flash')

async def generate_recipe_from_image(image_bytes: bytes):
    prompt = """
    Analyze this image of ingredients. 
    Create a detailed recipe using these items. 
    
    CRITICAL: Return ONLY raw JSON. Do not use Markdown (```json).
    Use this exact structure:
    {
        "title": "Recipe Name",
        "ingredients": ["item 1", "item 2"],
        "instructions": ["step 1", "step 2"],
        "difficulty": "Easy/Medium/Hard",
        "cooking_time": "15 mins"
    }
    """
    
    try:
        response = model.generate_content([
            {'mime_type': 'image/jpeg', 'data': image_bytes},
            prompt
        ])
        
        # Cleanup response
        clean_text = response.text.replace('```json', '').replace('```', '').strip()
        return json.loads(clean_text)
        
    except Exception as e:
        print(f"AI Error: {e}")
        return {
            "title": "Error",
            "ingredients": [],
            "instructions": ["Could not understand image."],
            "difficulty": "N/A",
            "cooking_time": "0"
        }