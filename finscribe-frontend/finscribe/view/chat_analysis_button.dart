// import 'package:flutter/material.dart';
// import 'package:fyp/services/invoice_services.dart';
// import 'package:fyp/mdemo.dart';
// import 'package:fyp/Utils/components/colors.dart';
// import 'package:fyp/view/chat_screen.dart';
// import 'package:intl/intl.dart';
//
// import '../model/invoice_model.dart';
//
// class ChatAnalysisButton extends StatelessWidget {
//   final String buttonText;
//   final Map<String, dynamic>? additionalData;
//
//
//   const ChatAnalysisButton({
//     Key? key,
//     this.buttonText = "Analyze with AI",
//     this.additionalData,
//   }) : super(key: key);
//
//   Future<void> _navigateToChatScreen(BuildContext context) async {
//     try {
//       // Show loading indicator
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Center(child: CircularProgressIndicator()),
//       );
//
//       // Fetch all required data
//       final dailySpending = await fetchDailySpending();
//       final vendorFrequency = await fetchVendorFrequency();
//       final productData = await InvoiceService().fetchAggregatedProductData();
//
//       // Combine with any additional data passed to the button
//       final combinedProductData = {
//         ...productData,
//         ...?additionalData,
//       };
//
//       // Close loading dialog
//       Navigator.of(context).pop();
//
//       // Navigate to ChatScreen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatScreen(
//             dailySpending: dailySpending,
//             vendorFrequency: vendorFrequency,
//             productData: combinedProductData,
//             chartData: vendorFrequency,
//           ),
//         ),
//       );
//     } catch (e) {
//       // Close loading dialog if still open
//       Navigator.of(context).pop();
//
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load data: ${e.toString()}')),
//       );
//     }
//   }
//
//   Future<Map<String, double>> fetchDailySpending() async {
//     String selectedRange = 'All';
//     try {
//       List<Invoice> invoices = await InvoiceService().fetchInvoices();
//       Map<String, double> spendingMap = {};
//       final now = DateTime.now();
//
//       for (var invoice in invoices) {
//         try {
//           final invoiceDate = DateFormat('MM/dd/yyyy').parse(invoice.invoiceDate);
//           final dateKey = DateFormat('MM/dd/yyyy').format(invoiceDate);
//
//           // Apply filter
//           if (selectedRange == '7 days' && invoiceDate.isBefore(now.subtract(Duration(days: 7)))) {
//             continue;
//           } else if (selectedRange == '30 days' && invoiceDate.isBefore(now.subtract(Duration(days: 30)))) {
//             continue;
//           }
//
//           spendingMap.update(
//             dateKey,
//                 (value) => value + invoice.invoiceSummary.totalPrice,
//             ifAbsent: () => invoice.invoiceSummary.totalPrice,
//           );
//         } catch (e) {
//           print("Error parsing date: ${invoice.invoiceDate}");
//         }
//       }
//
//       return spendingMap;
//     } catch (e) {
//       print('Error fetching daily spending: $e');
//       throw Exception('Failed to fetch daily spending');
//     }
//   }
//
//
//   Future<Map<String, int>> fetchVendorFrequency() async {
//     try {
//       List<Invoice> invoices = await InvoiceService().fetchInvoices();
//
//       Map<String, int> frequencyMap = {};
//       for (var invoice in invoices) {
//         String vendor = invoice.vendorName.trim();
//         if (vendor.isEmpty) continue;
//
//         frequencyMap.update(vendor, (value) => value + 1, ifAbsent: () => 1);
//       }
//
//       return frequencyMap;
//     } catch (e) {
//       print('Error fetching vendor frequency: $e');
//       throw Exception('Failed to fetch vendor frequency');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           // colors: [Color(0xFF399d4e), Color(0xFF25fcb5)],
//           colors: [
//             Color(0xFF17A2B8),
//             Color(0xFF20C997),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ElevatedButton.icon(
//         onPressed: () => _navigateToChatScreen(context),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         icon: Icon(Icons.chat, color: Colors.white),
//         label: Text(buttonText, style: TextStyle(color: Colors.white)),
//       ),
//     );
//
//   }
// }
//
//
// // return DecoratedBox(
// //     decoration: BoxDecoration(
// //       gradient: LinearGradient(
// //         colors: [Color(0xFF399d4e), Color(0xFF25fcb5)],
// //       ),
// //       borderRadius: BorderRadius.circular(10),
// //     ),
// //     child: ElevatedButton.icon(
// //       onPressed: () => _navigateToChatScreen(context),
// //       icon: Icon(Icons.chat, color: Colors.white),
// //       label: Text(
// //         buttonText,
// //         style: TextStyle(color: Colors.white),
// //       ),
// //       style: ElevatedButton.styleFrom(
// //         backgroundColor: Colors.transparent,
// //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //       ),
// //     ),
// // );









import 'package:flutter/material.dart';
import 'package:fyp/services/chatbot_service.dart';
import 'package:fyp/view/chat_screen.dart';

class ChatAnalysisButton extends StatelessWidget {
  final String buttonText;
  final Map<String, dynamic>? additionalData;

  const ChatAnalysisButton({
    Key? key,
    this.buttonText = "Analyze with AI",
    this.additionalData,
  }) : super(key: key);

  Future<void> _navigateToChatScreen(BuildContext context) async {
    final chatbotService = ChatbotService();

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Call API via service
      final responseData = await chatbotService.fetchChatAnalysisData();

      print("🔥 Response from API:");
      print(responseData);

      // Merge data
      final combinedProductData = {
        ...?responseData['productData'],
        ...?additionalData,
      };

      // Hide loading
      Navigator.of(context).pop();

      // Navigate to ChatScreen (update this to your real screen and parameters)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            fullData: responseData,
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF17A2B8),
            Color(0xFF20C997),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton.icon(
        onPressed: () => _navigateToChatScreen(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: const Icon(Icons.chat, color: Colors.white),
        label: Text(buttonText, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

