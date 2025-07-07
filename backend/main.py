from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
import pytesseract
import numpy as np
import os
from io import BytesIO
import base64
import cv2

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

    # Convert to grayscale.
    if len(img_arr.shape) == 3:
        img_arr = cv2.cvtColor(img_arr, cv2.COLOR_RGB2GRAY)
    
    # Make picture display using binary colors: black and white. This is needed for OCR.
    img_arr = cv2.threshold(img_arr, 160, 255, cv2.THRESH_BINARY)[1]

    """cv2.imshow("Processed Image", img_arr)
    cv2.waitKey(0)
    cv2.destroyAllWindows()"""

    text = pytesseract.image_to_string(img_arr)
    print(text)
    
    return text