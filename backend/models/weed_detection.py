import tensorflow as tf
import numpy as np
from PIL import Image
from io import BytesIO

class WeedDetectionModel:
    def __init__(self, model_path: str):
        self.model = tf.keras.models.load_model(model_path)

    def predict(self, image: Image.Image):
        image = image.resize((224, 224))
        image_array = np.array(image) / 255.0
        image_array = np.expand_dims(image_array, axis=0)
        prediction = self.model.predict(image_array)
        return prediction

    def detect_weeds(self, image: Image.Image):
        prediction = self.predict(image)
        if prediction[0][0] > 0.5:  # Threshold to determine if it's a weed
            return True
        return False

# Create model instance and load the model
model = WeedDetectionModel("models/weed_nonweed_model.h5")