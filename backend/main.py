from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
import pytesseract
import numpy as np
import os
from io import BytesIO
import base64

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
    
    # Decode filedata.
    image_data = base64.b64decode(data["filedata"])
    image = Image.open(BytesIO(image_data))

    img_arr = np.array(image)
    text = pytesseract.image_to_string(img_arr)
    print(text)
    
    return text