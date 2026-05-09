"""
schemas.py — Pydantic request/response models for Sapience AI Backend.
These define what data the API accepts and returns.
"""

from pydantic import BaseModel, EmailStr, Field
from typing import Optional
import datetime


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class SyncReportRequest(BaseModel):
    user_id: str
    report_date: datetime.date
    data_type: str = Field(pattern="^(voice|typing|gait)$")
    stability_score: int = Field(ge=0, le=100)
    encrypted_summary: str


class ApiResponse(BaseModel):
    success: bool
    message: str
    data: Optional[dict] = None
