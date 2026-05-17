import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/invoice_model.dart';

class InvoiceService {
  static const String baseUrl = 'https://data-digitization.vercel.app';

  Future<List<Invoice>> fetchInvoices() async {
    final url = Uri.parse('$baseUrl/receipts');


    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No auth token found. Please log in.');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => Invoice.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load invoices: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching invoices: $e');
      rethrow;
    }
  }



  Future<Map<String, Map<String, dynamic>>> fetchAggregatedProductData() async {
    List<Invoice> invoices = await InvoiceService().fetchInvoices();

    Map<String, Map<String, dynamic>> productMap = {};

    for (var invoice in invoices) {
      for (var product in invoice.products) {
        String name = product.productName.trim();

        if (!productMap.containsKey(name)) {
          productMap[name] = {
            'type' : product.productType,
            'category': product.productCategory,
            'quantity': product.quantity,
            'totalPrice': product.unitPrice * product.quantity,
          };
        } else {
          productMap[name]!['quantity'] += product.quantity;
          productMap[name]!['totalPrice'] += product.unitPrice * product.quantity;
        }
      }
    }

    return productMap;
  }




  // Future<List<Invoice>> fetchInvoices() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');
  //
  //   if (token == null) {
  //     throw Exception('Not authenticated - please login again');
  //   }
  //
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/invoices'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  //
  //   if (response.statusCode == 401) {
  //     throw Exception('Session expired - please login again');
  //   }
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to load invoices: ${response.statusCode}');
  //   }
  //
  //   return parseInvoices(response.body);
  // }

}
