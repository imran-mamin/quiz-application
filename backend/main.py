from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
import pytesseract
import numpy as np
import os

app = FastAPI()

# Allow frontend to access backend (FastAPI on 8000)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # ["*"] for all (dev only)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/image-to-text")
async def text_from_image_ocr(request: Request):
    data = await request.json()
    print(data)
    filename = os.path.join(os.path.dirname(__file__), 'image_01.png')
    img1 = np.array(Image.open(filename))
    text = pytesseract.image_to_string(img1)
    print(text)
    return text