from fastapi import APIRouter, UploadFile, File
from fastapi.responses import JSONResponse
from io import BytesIO
from PIL import Image
from models.weed_detection import WeedDetectionModel
from config import settings  # Make sure the import path is correct

# Create the router instance
router = APIRouter()

# Initialize the model
model = WeedDetectionModel(settings.MODEL_PATH)

@router.post("/detect-weed/")
async def detect_weed(file: UploadFile = File(...)):
    try:
        # Read the uploaded file
        image_bytes = await file.read()
        image = Image.open(BytesIO(image_bytes))

        # Detect weeds in the image
        is_weed = model.detect_weeds(image)

        if is_weed:
            return JSONResponse(content={"message": "Weeds detected!", "has_weeds": True})
        else:
            return JSONResponse(content={"message": "No weeds detected.", "has_weeds": False})

    except Exception as e:
        return JSONResponse(content={"message": str(e), "status": "error"}, status_code=400)
