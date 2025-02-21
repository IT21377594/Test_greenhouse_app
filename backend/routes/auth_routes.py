from fastapi import APIRouter, HTTPException
from database import users_collection
from models.user_model import UserCreate, UserLogin
from passlib.hash import bcrypt
import jwt
from config import JWT_SECRET

router = APIRouter()

def create_jwt(email):
    return jwt.encode({"email": email}, JWT_SECRET, algorithm="HS256")

@router.post("/signup")
def signup(user: UserCreate):
    if users_collection.find_one({"email": user.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    
    hashed_password = bcrypt.hash(user.password)
    users_collection.insert_one({"name": user.name, "email": user.email, "password": hashed_password})
    return {"message": "User registered successfully"}

@router.post("/signin")
def signin(user: UserLogin):
    db_user = users_collection.find_one({"email": user.email})
    if not db_user or not bcrypt.verify(user.password, db_user["password"]):
        raise HTTPException(status_code=400, detail="Invalid credentials")
    
    token = create_jwt(user.email)
    return {"token": token, "message": "Signin successful"}