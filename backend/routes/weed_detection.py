from fastapi import APIRouter, UploadFile, File
from fastapi.responses import JSONResponse
from io import BytesIO
from PIL import Image
from models.weed_detection import WeedDetectionModel
from config import settings

router = APIRouter()

# Load the model
model = WeedDetectionModel(settings.MODEL_PATH)

@router.post("/detect-weed/")
async def detect_weed(file: UploadFile = File(...)):
    try:
        # Read image file
        image_bytes = await file.read()
        image = Image.open(BytesIO(image_bytes))

        print("Image received. Processing...")  # Debugging log

        # Detect weeds and bounding boxes
        result = model.detect_weeds(image)

        print("Model Output:", result)  # Debugging log

        return JSONResponse(content=result)

    except Exception as e:
        print("API Error:", str(e))
        return JSONResponse(content={"message": str(e), "status": "error"}, status_code=400)