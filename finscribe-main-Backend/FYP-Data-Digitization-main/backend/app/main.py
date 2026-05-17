from fastapi import FastAPI
from app.routes import auth, receipt,session
from app.database import get_db
app = FastAPI()

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(session.router, prefix="/session", tags=["auth"])

app.include_router(receipt.router, prefix="/receipts", tags=["receipts"])

@app.get("/")
def read_root():
    return {"message": "Welcome to the Financial Data Digitization System!"}


