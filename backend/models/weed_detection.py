import tensorflow as tf
import numpy as np
import cv2
from PIL import Image

class WeedDetectionModel:
    def __init__(self, model_path: str):
        self.model = tf.keras.models.load_model(model_path)

    def predict(self, image: Image.Image):
        """Preprocess image and make a prediction"""
        image = image.resize((224, 224))
        image_array = np.array(image) / 255.0
        image_array = np.expand_dims(image_array, axis=0)

        prediction = self.model.predict(image_array)
        return prediction

    def detect_weeds(self, image: Image.Image):
        """Detects weeds and returns bounding boxes"""
        prediction = self.predict(image)
        print("🔍 Prediction Output:", prediction)  # Debugging log

        # If using a classification model, return fake bounding boxes for now
        if prediction[0][0] > 0.5:  # If the model predicts weed presence
            print("Weed Detected!")

            # Fake bounding boxes (Replace with real object detection output)
            boxes = [[0.2, 0.3, 0.6, 0.7], [0.4, 0.5, 0.8, 0.9]]

            return {"has_weeds": True, "boxes": boxes}
        else:
            print("No weeds detected.")
            return {"has_weeds": False, "boxes": []}

# Load model instance
model = WeedDetectionModel("models/weed_nonweed_model.h5")
