import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/components/colors.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

  bool _isLoading = false;

  // Header Controllers Map
  final Map<String, TextEditingController> _headerControllers = {};

  // Summary Controllers Map
  final Map<String, TextEditingController> _summaryControllers = {};

  // Header Controllers
  final vendorNameController = TextEditingController();
  final invoiceNumberController = TextEditingController();
  final invoiceDateController = TextEditingController();

// Summary Controllers
  final subTotalController = TextEditingController();
  final gstController = TextEditingController();
  final otherTaxesController = TextEditingController();
  final taxController = TextEditingController();
  final totalQuantityController = TextEditingController();
  final totalPriceController = TextEditingController();
  final discountController = TextEditingController();

  List<Map<String, TextEditingController>> _productControllers = [];

  @override
  void initState() {
    super.initState();
    _addNewProduct();

    _headerControllers.addAll({
      "Vendor Name": vendorNameController,
      "Invoice Number": invoiceNumberController,
      "Invoice Date": invoiceDateController,
    });

    _summaryControllers.addAll({
      "Sub Total": subTotalController,
      "GST": gstController,
      "Other Taxes": otherTaxesController,
      "Tax": taxController,
      "Total Quantity": totalQuantityController,
      "Total Price": totalPriceController,
      "Discount": discountController,
    });
  }


  void _addNewProduct() {
    setState(() {
      _productControllers.add({
        "Product Name": TextEditingController(),
        "Product Type": TextEditingController(),
        "Product Category": TextEditingController(),
        "Unit Price": TextEditingController(),
        "Quantity": TextEditingController(),
        "Total Product Price": TextEditingController(),
      });
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _productControllers.removeAt(index);
    });
  }

  void _submitData() async {
    // Validate
    if (vendorNameController.text.isEmpty ||
        invoiceNumberController.text.isEmpty ||
        invoiceDateController.text.isEmpty ||
        subTotalController.text.isEmpty ||
        totalPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    //Load token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are not logged in")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final uri = Uri.parse('https://data-digitization.vercel.app/receipts/manual');

    final body = {
      "vendor_name": vendorNameController.text,
      "invoice_number": invoiceNumberController.text,
      "invoice_date": invoiceDateController.text,
      "products": _productControllers.map((product) {
        return {
          "product_name": product["Product Name"]!.text,
          "product_type": product["Product Type"]!.text,
          "product_category": product["Product Category"]!.text,
          "unit_price": double.tryParse(product["Unit Price"]!.text) ?? 0.0,
          "quantity": int.tryParse(product["Quantity"]!.text) ?? 0,
          "total_product_price": double.tryParse(product["Total Product Price"]!.text) ?? 0.0,
        };
      }).toList(),
      "invoice_summary": {
        "sub_total": double.tryParse(subTotalController.text) ?? 0.0,
        "gst": double.tryParse(gstController.text) ?? 0.0,
        "other_taxes": double.tryParse(otherTaxesController.text) ?? 0.0,
        "tax": double.tryParse(taxController.text) ?? 0.0,
        "total_quantity": int.tryParse(totalQuantityController.text) ?? 0,
        "total_price": double.tryParse(totalPriceController.text) ?? 0.0,
        "discount": double.tryParse(discountController.text) ?? 0.0,
      }
    };

    print("TOKEN USED: Bearer $token");


    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print('Status: ${response.statusCode}');
      print('Login Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Submitted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Submission failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }

    setState(() {
      _isLoading = false;
    });

    print(jsonEncode(body));
  }


  void debugPrintStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("STORED TOKEN: $token");
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appbarColor,
        title: Text(
          "Upload Manually",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            BuildSection(
              title: "Invoice Header",
              children: [
                BuildInputRow(["Vendor Name", "Invoice Number"], _headerControllers),
                BuildInputRow(["Invoice Date"], _headerControllers),
              ],
            ),

            BuildSection(
              title: "Product Details",
              children: [
                ..._productControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product ${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.text,
                            ),
                          ),
                          if (_productControllers.length > 1)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeProduct(index),
                            ),
                        ],
                      ),
                      BuildDynamicInputRow(["Product Name", "Product Type"], product),
                      BuildDynamicInputRow(["Product Category", "Unit Price"], product),
                      BuildDynamicInputRow(["Quantity", "Total Product Price"], product),
                      const Divider(thickness: 1),
                    ],
                  );
                }),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addNewProduct,
                    icon: Icon(Icons.add, color: AppColors.text),
                    label: Text("Add Product", style: TextStyle(color: AppColors.text)),
                  ),
                ),
              ],
            ),

            BuildSection(
              title: "Invoice Details",
              children: [
                BuildInputRow(["Sub Total", "GST"], _summaryControllers),
                BuildInputRow(["Other Taxes", "Tax"], _summaryControllers),
                BuildInputRow(["Total Quantity", "Total Price"], _summaryControllers),
                BuildInputRow(["Discount"], _summaryControllers),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitData ,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.text,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: _isLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : Text("Submit", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget BuildSection({required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget BuildInputRow(List<String> labels, Map<String, TextEditingController> controllerMap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: labels.map((label) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$label:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controllerMap[label],
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget BuildInputField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      ],
    );
  }

  Widget BuildDynamicInputRow(List<String> labels, Map<String, TextEditingController> controllerMap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: labels.map((label) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$label:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controllerMap[label],
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

}
