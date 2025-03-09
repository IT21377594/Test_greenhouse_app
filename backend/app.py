from fastapi import FastAPI
from routes.auth_routes import router as auth_router
from routes.weed_detection import router as weed_detection_router

app = FastAPI()

app.include_router(auth_router, prefix="/auth")
app.include_router(weed_detection_router, prefix="/weed")  # Added prefix

@app.get("/")
def home():
    return {"message": "Welcome to the API"}