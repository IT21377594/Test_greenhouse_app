from fastapi import FastAPI
from routes.auth_routes import router as auth_router
from routes.weed_detection import router as weed_detection_router  # Import the new weed detection route

app = FastAPI()

app.include_router(auth_router, prefix="/auth")
# Include the new route for weed detection
app.include_router(weed_detection_router)

@app.get("/")
def home():
    return {"message": "Welcome to the API"}