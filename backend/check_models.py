import google.generativeai as genai
import os

# PASTE YOUR KEY HERE
os.environ["GOOGLE_API_KEY"] = "AIzaSyDFXBoMxYJi7xOfFBSZI3ba5bZrINnnUqw"
genai.configure(api_key=os.environ["GOOGLE_API_KEY"])

print("Searching for available models...")
try:
    for m in genai.list_models():
        if 'generateContent' in m.supported_generation_methods:
            print(f"- {m.name}")
except Exception as e:
    print(f"Error: {e}")