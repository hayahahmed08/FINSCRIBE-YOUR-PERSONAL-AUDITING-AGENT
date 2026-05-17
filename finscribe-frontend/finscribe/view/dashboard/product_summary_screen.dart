import 'package:flutter/material.dart';
import 'package:fyp/services/invoice_services.dart';

import '../../Utils/components/colors.dart';
import '../chat_analysis_button.dart';
import '../../mdemo.dart';

class ProductLevelInsights extends StatefulWidget {
  @override
  _ProductLevelInsightsState createState() => _ProductLevelInsightsState();
}

class _ProductLevelInsightsState extends State<ProductLevelInsights> {
  late Future<Map<String, Map<String, dynamic>>> productData;
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();
    productData = InvoiceService().fetchAggregatedProductData();
  }

  // void _navigateToChatScreen(Map<String, Map<String, dynamic>> data) {
  //   // Convert the data to a format that ChatScreen expects
  //   Map<String, double> simplifiedData = {};
  //   data.forEach((key, value) {
  //     simplifiedData[key] = value['totalPrice'] ?? 0.0;
  //   });
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ChatScreen(chartData: simplifiedData),
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        title: Text(
          "All Product summary",
          style: TextStyle(
            color: AppColors.background2,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FutureBuilder<Map<String, Map<String, dynamic>>>(
              future: productData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));

                final data = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.green.shade100),
                    columnSpacing: 30,
                    dataRowHeight: 60,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                    columns: const [
                      DataColumn(label: Text("Product Name")),
                      DataColumn(label: Text("Product Category")),
                      DataColumn(label: Text("Category")),
                      DataColumn(label: Text("Total Quantity")),
                      DataColumn(label: Text("Total Price")),
                    ],
                    rows: data.entries.map((entry) {
                      final name = entry.key;
                      final info = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text(name, style: TextStyle(fontSize: 16))),
                          DataCell(Text(info['type'],
                              style: TextStyle(fontSize: 16))),
                          DataCell(Text(info['category'] ?? '',
                              style: TextStyle(fontSize: 16))),
                          DataCell(Text(info['quantity'].toString(),
                              style: TextStyle(fontSize: 16))),
                          DataCell(Text(
                              '${info['totalPrice'].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16))),
                        ],
                      );
                    }).toList(),
                  ),
                );

              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton.icon(
            //     onPressed: () async {
            //       final data = await productData;
            //       _navigateToChatScreen(data);
            //     },
            //     icon: Icon(Icons.chat),
            //     label: Text("Ask about this chart"),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.appbarColor,
            //       foregroundColor: Colors.white,
            //     ),
            //   ),
            // ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton.icon(
            //     onPressed: () async {
            //       final dailySpending = await fetchDailySpending();
            //       final vendorFrequency = await fetchVendorFrequency();
            //       final productData = await InvoiceService().fetchAggregatedProductData();
            //     },
            //     icon: Icon(Icons.chat),
            //     label: Text("Ask about this chart"),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.appbarColor,
            //       foregroundColor: Colors.white,
            //     ),
            //   ),
            // ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: ChatAnalysisButton(),
            ),

          ],
        ),
      ),
    );
  }
}
