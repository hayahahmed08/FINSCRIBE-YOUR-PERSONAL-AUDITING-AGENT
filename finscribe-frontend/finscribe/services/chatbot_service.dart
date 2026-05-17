import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotService {
  static const String _baseUrl = 'https://data-digitization.vercel.app';

  Future<Map<String, dynamic>> fetchChatAnalysisData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No auth token found. Please log in.');
    }

    final url = Uri.parse('$_baseUrl/receipts/analysis');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('API call failed: ${response.statusCode} - ${response.body}');
    }
  }
}
