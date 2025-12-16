# snapcook_backend/schemas.py
from pydantic import BaseModel
from typing import List

class RecipeResponse(BaseModel):
    title: str
    ingredients: List[str]
    instructions: List[str]
    difficulty: str
    cooking_time: str