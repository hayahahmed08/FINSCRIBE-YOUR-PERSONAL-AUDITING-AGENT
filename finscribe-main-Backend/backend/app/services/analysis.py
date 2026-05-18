from typing import Dict, List
from datetime import datetime
from collections import defaultdict
from app.models.receipt import ReceiptInDB, ReceiptsAnalysis
from app.services.receipt import get_receipts

def parse_date(date_str: str) -> datetime:
    """Try multiple date formats to parse the invoice date"""
    formats = [
        "%m/%d/%Y",  # MM/DD/YYYY
        "%d/%m/%Y",  # DD/MM/YYYY
        "%Y-%m-%d",  # YYYY-MM-DD
    ]
    
    for fmt in formats:
        try:
            return datetime.strptime(date_str, fmt)
        except ValueError:
            continue
    
    print(f"[ANALYSIS SERVICE] Unable to parse date: {date_str}")
    return None

def analyze_receipts(receipts: List[ReceiptInDB]) -> Dict:
    """Analyze receipts data and return statistics for dashboard"""
    print("[ANALYSIS SERVICE] Starting receipt analysis...")
    
    try:
        # Initialize totals
        total_spending = 0.0
        total_quantity = 0
        total_taxes = 0.0
        total_discounts = 0.0
        
        # Data structures for analysis
        vendors_spending = defaultdict(float)
        category_spending = defaultdict(float)
        monthly_spending = defaultdict(float)
        daily_spending = defaultdict(float)
        
        days_order = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        print(f"[ANALYSIS SERVICE] Processing {len(receipts)} receipts...")
        
        for i, receipt in enumerate(receipts, 1):
            try:
                # Skip receipts with invalid totals
                if receipt.invoice_summary.total_price <= 0:
                    print(f"[ANALYSIS SERVICE] Skipping receipt {i} with invalid total price")
                    continue
                
                # Calculate summary totals
                total_spending += receipt.invoice_summary.total_price
                total_quantity += receipt.invoice_summary.total_quantity
                total_taxes += receipt.invoice_summary.tax
                total_discounts += receipt.invoice_summary.discount
                
                # Vendor analysis
                vendors_spending[receipt.vendor_name] += receipt.invoice_summary.total_price
                
                # Category analysis
                for product in receipt.products:
                    if product.total_product_price > 0:  # Only count valid products
                        category_spending[product.product_category] += product.total_product_price
                    
                # Monthly and daily analysis
                invoice_date = parse_date(receipt.invoice_date)
                if invoice_date:
                    month_year = f"{invoice_date.strftime('%B')} {invoice_date.year}"
                    monthly_spending[month_year] += receipt.invoice_summary.total_price
                    day_of_week = invoice_date.strftime("%A")
                    daily_spending[day_of_week] += receipt.invoice_summary.total_price
                else:
                    print(f"[ANALYSIS SERVICE] Invalid date in receipt {i}: {receipt.invoice_date}")
                    
            except Exception as e:
                print(f"[ANALYSIS SERVICE] Error processing receipt {i}: {str(e)}")
                print(f"[ANALYSIS SERVICE] Problematic receipt data: {receipt.dict()}")
                continue
        
        # Prepare analysis results
        result = {
            "summary": {
                "total_spending": round(total_spending, 2),
                "total_quantity": total_quantity,
                "total_taxes": round(total_taxes, 2),
                "total_discounts": round(total_discounts, 2)
            },
            "top_vendors": [],
            "top_categories": [],
            "monthly_spending": [],
            "daily_spending": [],
            "Detail_data": receipts
        }
        
        # Get top 10 vendors
        try:
            top_vendors = sorted(
                vendors_spending.items(), 
                key=lambda x: x[1], 
                reverse=True
            )[:10]
            result["top_vendors"] = [{"name": k, "amount": v} for k, v in top_vendors]
        except Exception as e:
            print(f"[ANALYSIS SERVICE] Error processing vendors: {str(e)}")
        
        # Get top categories
        try:
            top_categories = sorted(
                category_spending.items(),
                key=lambda x: x[1],
                reverse=True
            )[:10]
            result["top_categories"] = [{"name": k, "amount": v} for k, v in top_categories]
        except Exception as e:
            print(f"[ANALYSIS SERVICE] Error processing categories: {str(e)}")
        
        # Prepare monthly spending data
        try:
            monthly_data = sorted(
                monthly_spending.items(),
                key=lambda x: datetime.strptime(x[0], "%B %Y")
            )
            result["monthly_spending"] = [{"month": k, "amount": v} for k, v in monthly_data]
        except Exception as e:
            print(f"[ANALYSIS SERVICE] Error processing monthly data: {str(e)}")
        
        # Prepare daily spending data in correct order
        try:
            daily_data = []
            for day in days_order:
                if day in daily_spending:
                    daily_data.append({"day": day, "amount": daily_spending[day]})
            result["daily_spending"] = daily_data
        except Exception as e:
            print(f"[ANALYSIS SERVICE] Error processing daily data: {str(e)}")
        
        print("[ANALYSIS SERVICE] Analysis completed successfully")
        return result
        
    except Exception as e:
        print(f"[ANALYSIS SERVICE] Critical error during analysis: {str(e)}")
        raise

async def get_receipts_analysis(user_id: str) -> Dict:
    """Get and analyze receipts for a user"""
    print(f"[ANALYSIS SERVICE] Getting analysis for user {user_id}...")
    try:
        receipts = await get_receipts(user_id)
        if not receipts:
            print("[ANALYSIS SERVICE] No receipts found for user")
            return {
                "summary": {
                    "total_spending": 0.0,
                    "total_quantity": 0,
                    "total_taxes": 0.0,
                    "total_discounts": 0.0
                },
                "top_vendors": [],
                "top_categories": [],
                "monthly_spending": [],
                "daily_spending": []

            }
        return analyze_receipts(receipts)
    except Exception as e:
        print(f"[ANALYSIS SERVICE] Error getting receipts for analysis: {str(e)}")
def get_receipts_analysis(user_id: str) -> Dict:
    """Get and analyze receipts for a user"""
    receipts = get_receipts(user_id)
    print(receipts)
    return analyze_receipts(receipts)