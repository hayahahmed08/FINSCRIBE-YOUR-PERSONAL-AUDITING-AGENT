import json
import google.generativeai as genai
from datetime import datetime
import os
import tempfile

genai.configure(api_key=os.environ["API_KEY"])

def extract_info_from_file(file_content: bytes) -> dict:
    """
    Extract information from an image or PDF file using the Google Generative AI model.

    Args:
        file_content (bytes): The content of the uploaded file.

    Returns:
        dict: A dictionary containing either the extracted data or an error message.
              Example:
              - On success: {"status": "success", "data": {...}}
              - On error: {"status": "error", "error": "Error message"}
    """
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as temp_file:
          temp_file.write(file_content)
          temp_file_path = temp_file.name

        # Initialize the model
        model = genai.GenerativeModel("gemini-2.0-flash")

        # Upload the file content
        file = genai.upload_file(temp_file_path)

        # Define the prompt (assume it's defined elsewhere or loaded from a config)
        prompt="""Extract specific fields from a clear and non-blurry image if it represents an invoice or financial report. If the image is blurry, return an error message indicating that the image is unacceptable for processing. Focus on extracting the following information accurately and structuring it in the specified JSON format.

      ### Fields to Extract:

  1. **General Information:**
   - **Vendor Name**: Extract the name of the vendor or the title of the invoice/receipt (if available). If missing, set to `-`.
   - **Invoice/Receipt Number**: Extract the unique identifier for the invoice or receipt. If missing, set to `-`.
   - **Invoice Date**: Extract the invoice date in the format `MM/DD/YYYY`. If unavailable, default to today's date.

2. **Product Details:**
   - **Product Name**: Extract the full name of each product listed on the invoice (e.g., "Brite Washing Powder"). If missing, set to `-`.
   - **Product Type**: Extract a general description of the product based on the **Product Name**. For example:
     - If the product is "Brite Washing Powder," the **Product Type** will be "Washing Powder."
     - If the product is "Apple iPhone 15," the **Product Type** will be "Smartphone."
     - If the product is "Nike Air Max," the **Product Type** will be "Shoes."
     - If the **Product Name** is missing, set the **Product Type** to `None`.
   - **Product Category**: Infer the **Product Category** based on the **Product Type** using common sense. For example:
     - If the product is "Washing Powder," the **Product Category** will be "Household."
     - If the product is "Smartphone," the **Product Category** will be "Electronics."
     - If the product is "Shoes," the **Product Category** will be "Apparel."
     - If the **Product Type** is missing, set the **Product Category** to `-`.
   - **Unit Price**: Extract the unit price of each product. If missing, set to `0`.
   - **Product Quantity**: Extract the quantity of each product. If missing, set to `0`.
   - **Total Product Price**: Calculate the total price for each product as `Unit Price * Product Quantity`. If the calculated value does not match the extracted value from the invoice, use the extracted value as the fallback.

3. **Invoice Summary:**
   - **Sub-total**: Extract the subtotal amount from the invoice/receipt. If unavailable, calculate it as the sum of all **Total Product Prices**. If both are missing, use the **Total Price** as a fallback value.
   - **GST (Goods and Services Tax)**: Extract the **GST** value, which typically appears as a specific tax line in the invoice. If **GST** is unavailable or not found, set it to `0`. Extract only the **rightmost value** from the line containing the **GST** label. Ensure that this value is a real number and does not contain any percentage sign (`%`).
   - **Other Taxes**: Extract any additional tax values (e.g., provincial tax, state tax, etc.) that appear as separate lines in the invoice. If no other taxes are found, set this to `0`. Extract only the **rightmost value** from the line containing the tax label. Ensure that this value is a real number and does not contain any percentage sign (`%`).
   - **Tax**: Calculate the **total tax** as the sum of **GST** and **Other Taxes**. This total tax value must be equal to `GST + Other Taxes`. If either **GST** or **Other Taxes** is missing, you can set the tax value to `0`. Ensure the tax calculation matches the values in the invoice and the sum of the **GST** and **Other Taxes**.
   - **Total Quantity**: Extract the **Total Quantity** of all products from the invoice if it is explicitly mentioned. If not, calculate it as the sum of all individual **Product Quantities**.
   - **Total Price**: Extract the **Total Price** from the invoice, which is the final amount after taxes and discounts have been applied. If the **Total Price** is unavailable, set it to `0`.
   - **Discount**: Extract any discounts applied to the invoice/receipt total. If no discount is found, set it to `0`.

### Extraction Logic:

1. **Product Details:**
   - For each product, extract the **Unit Price**, **Product Quantity**, and **Total Product Price**.
   - Validate that the **Total Product Price** matches the calculation `Unit Price * Product Quantity`. If it does not match, use the extracted value as the fallback.
   - Extract the **Product Name** as the full name of the product (e.g., "Brite Washing Powder").
   - Extract the **Product Type** as a general description of the product (e.g., "Washing Powder").
   - Infer the **Product Category** based on the **Product Type** using common sense (e.g., "Household," "Electronics," "Apparel," etc.).

2. **Sub-total**:
   - Extract the **Sub-total** from the invoice. If unavailable, calculate it as the sum of all **Total Product Prices**. If both are missing, use the **Total Price** as a fallback.

3. **GST and Other Taxes**:
   - Extract the values for **GST** and **Other Taxes** from the invoice. These values must be extracted from the **rightmost** position of the line where these labels appear, ensuring that they are real numbers (and not percentages).

4. **Tax Validation**:
   - The **Tax** value is the sum of **GST** and **Other Taxes**. Ensure that the **tax value** is equal to `GST + Other Taxes`. If it does not match, set the **Tax** to `0` as a fallback.

5. **Total Quantity**:
   - Extract the **Total Quantity** of all products if it is explicitly mentioned in the invoice. If not, calculate it as the sum of all individual **Product Quantities**.

6. **Final Price Calculation**:
   - Ensure that the **Total Price** is calculated correctly by adding **Sub-total** and **Tax**, minus any **Discounts** (if available). Validate that this matches the extracted **Total Price** from the invoice.

### Output Format:
The result should be structured in the following JSON format:

```json
{
  "vendor_name": value or "-",
  "invoice_number": value or "-",
  "invoice_date": "MM/DD/YYYY or today's date",

  "products": [
    {
      "product_name": value or "-",  // Full product name (e.g., "Brite Washing Powder")
      "product_type": value or "-",  // General product description (e.g., "Washing Powder")
      "product_category": value or "-",  // Broader classification (e.g., "Household")
      "unit_price": value or 0,
      "quantity": value or 0,
      "total_product_price": value or 0
    }
  ],

  "invoice_summary": {
    "sub_total": value or 0,
    "gst": value or 0,
    "other_taxes": value or 0,
    "tax": value or 0,
    "total_quantity": value or 0,
    "total_price": value or 0,
    "discount": value or 0
  }
}
"""

        # Generate content using the prompt
        response = model.generate_content([file, prompt])

        # Extract JSON from the response
        result = response.text
        start_index = result.find('{')
        end_index = result.rfind('}') + 1
        cleaned_result = result[start_index:end_index]

        # Parse the JSON
        response_json = json.loads(cleaned_result)

        # Delete the uploaded file to free up resource
        print(response_json)
        # Return the extracted data
        return response_json

    except json.JSONDecodeError:
        return {
            "status": "error",
            "error": "Error: Could not parse the response as JSON."
        }
    except Exception as e:
        return {
            "status": "error",
            "error": f"Error processing file: {str(e)}"
        }