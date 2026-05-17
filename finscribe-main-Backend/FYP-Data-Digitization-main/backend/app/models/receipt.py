from pydantic import BaseModel, Field
from typing import List
from datetime import datetime

class Product(BaseModel):
    product_name: str
    product_type: str
    product_category: str
    unit_price: float
    quantity: int
    total_product_price: float

class InvoiceSummary(BaseModel):
    sub_total: float
    gst: float
    other_taxes: float
    tax: float
    total_quantity: int
    total_price: float
    discount: float

class Receipt(BaseModel):
    vendor_name: str
    invoice_number: str
    invoice_date: str
    products: List[Product]
    invoice_summary: InvoiceSummary

class ReceiptInDB(Receipt):
    id: str = Field(alias="_id")
    user_id: str
    created_at: datetime
    updated_at: datetime


class AnalysisSummary(BaseModel):
    total_spending: float
    total_quantity: int
    total_taxes: float
    total_discounts: float

class VendorSpending(BaseModel):
    name: str
    amount: float

class CategorySpending(BaseModel):
    name: str
    amount: float

class MonthlySpending(BaseModel):
    month: str
    amount: float

class DailySpending(BaseModel):
    day: str  # e.g., "Monday", "Tuesday", etc.
    amount: float

class ReceiptsAnalysis(BaseModel):
    summary: AnalysisSummary
    top_vendors: List[VendorSpending]
    top_categories: List[CategorySpending]
    monthly_spending: List[MonthlySpending]
    daily_spending: List[DailySpending]
    Detail_data: List[ReceiptInDB]  # List of receipts for detailed analysis