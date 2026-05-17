// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:fyp/services/invoice_services.dart';
//
// import '../../Utils/components/colors.dart';
//
// class ProductCategoryVsTotalSpending extends StatefulWidget {
//   @override
//   _ProductCategoryVsTotalSpendingState createState() =>
//       _ProductCategoryVsTotalSpendingState();
// }
//
// class _ProductCategoryVsTotalSpendingState extends State<ProductCategoryVsTotalSpending> {
//   late Future<Map<String, Map<String, dynamic>>> productData;
//
//   @override
//   void initState() {
//     super.initState();
//     productData = InvoiceService().fetchAggregatedProductData();
//   }
//
//   double _calculateInterval(double maxCount) {
//     if (maxCount <= 10) return 1;
//     if (maxCount <= 50) return 5;
//     if (maxCount <= 100) return 10;
//     if (maxCount <= 500) return 50;
//     return 100;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.appbarColor,
//         title: Text(
//           "Category Product Count",
//           style: TextStyle(
//             color: AppColors.background,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: FutureBuilder<Map<String, Map<String, dynamic>>>(
//         future: productData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           final data = snapshot.data!;
//           final Map<String, int> categoryCounts = {};
//
//           data.forEach((_, info) {
//             final category = info['category'] ?? 'Uncategorized';
//             final quantity = (info['quantity'] as num?)?.toInt() ?? 0;
//             categoryCounts[category] = (categoryCounts[category] ?? 0) + quantity;
//           });
//
//           // Sort by count (highest to lowest)
//           final sortedEntries = categoryCounts.entries.toList()
//             ..sort((a, b) => b.value.compareTo(a.value));
//
//           final sortedCategories = sortedEntries.map((e) => e.key).toList();
//           final sortedCounts = sortedEntries.map((e) => e.value).toList();
//           final maxCount = sortedCounts.isNotEmpty
//               ? sortedCounts.reduce((a, b) => a > b ? a : b).toDouble()
//               : 0.0;
//
//           return Column(
//             children: [
//               // Bar Chart Section (Fixed Height)
//               Card(
//                 elevation: 2,
//                 child: SizedBox(
//                   height: 300,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: BarChart(
//                       BarChartData(
//                         alignment: BarChartAlignment.spaceAround,
//                         maxY: maxCount * 1.2,
//                         barTouchData: BarTouchData(enabled: true),
//                         gridData: FlGridData(show: false),
//                         titlesData: FlTitlesData(
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: (value, meta) {
//                                 final index = value.toInt();
//                                 if (index >= 0 && index < sortedCategories.length) {
//                                   return Transform.rotate(
//                                     angle: -0.3,
//                                     child: Text(
//                                       sortedCategories[index],
//                                       style: TextStyle(fontSize: 10),
//                                     ),
//                                   );
//                                 }
//                                 return SizedBox.shrink();
//                               },
//                               reservedSize: 60,
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               interval: _calculateInterval(maxCount),
//                               getTitlesWidget: (value, meta) => Text(
//                                 value.toInt().toString(),
//                                 style: TextStyle(fontSize: 10),
//                               ),
//                               reservedSize: 40,
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false)),
//                           rightTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false)),
//                         ),
//                         borderData: FlBorderData(show: false),
//                         barGroups: List.generate(sortedCategories.length, (index) {
//                           return BarChartGroupData(
//                             x: index,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: sortedCounts[index].toDouble(),
//                                 color: Colors.green,
//                                 width: 16,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ],
//                           );
//                         }),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // List View Section (Scrollable)
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0),
//                           child: Text(
//                             "Category-wise Product Count",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: sortedCategories.length,
//                           itemBuilder: (context, index) {
//                             final category = sortedCategories[index];
//                             final count = sortedCounts[index];
//                             return Card(
//                               margin: EdgeInsets.symmetric(vertical: 4),
//                               child: ListTile(
//                                 leading: Container(
//                                   width: 30,
//                                   height: 30,
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.grey[200],
//                                   ),
//                                   child: Text(
//                                     '${index + 1}',
//                                     style: TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   category,
//                                   style: TextStyle(fontWeight: FontWeight.w500),
//                                 ),
//                                 trailing: Text(
//                                   "$count products",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyp/services/invoice_services.dart';

import '../../Utils/components/colors.dart';
import '../chat_analysis_button.dart';
import '../../mdemo.dart';

class ProductCategoryVsTotalSpending extends StatefulWidget {
  @override
  _ProductCategoryVsTotalSpendingState createState() =>
      _ProductCategoryVsTotalSpendingState();
}

class _ProductCategoryVsTotalSpendingState extends State<ProductCategoryVsTotalSpending> {
  late Future<Map<String, Map<String, dynamic>>> productData;
  bool hasNavigated = false;
  Map<String, double> summary = {};

  @override
  void initState() {
    super.initState();
    productData = InvoiceService().fetchAggregatedProductData();
  }

  double _calculateInterval(double maxCount) {
    if (maxCount <= 10) return 1;
    if (maxCount <= 50) return 5;
    if (maxCount <= 100) return 10;
    if (maxCount <= 500) return 50;
    return 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        title: Text(
          "Category Product Count",
          style: TextStyle(
            color: AppColors.background2,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: productData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final Map<String, int> categoryCounts = {};

          data.forEach((_, info) {
            final category = info['category'] ?? 'Uncategorized';
            final quantity = (info['quantity'] as num?)?.toInt() ?? 0;
            categoryCounts[category] = (categoryCounts[category] ?? 0) + quantity;
          });

          // Sort by count (highest to lowest)
          final sortedEntries = categoryCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final sortedCategories = sortedEntries.map((e) => e.key).toList();
          final sortedCounts = sortedEntries.map((e) => e.value).toList();
          final maxCount = sortedCounts.isNotEmpty
              ? sortedCounts.reduce((a, b) => a > b ? a : b).toDouble()
              : 0.0;


          summary = {
            for (int i = 0; i < sortedCategories.length; i++)
              sortedCategories[i]: sortedCounts[i].toDouble()
          };


          // if (!hasNavigated) {
          //   hasNavigated = true;
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => ChatScreen(chartData: summary),
          //       ),
          //     );
          //   });
          // }

          return Column(
            children: [
              // Bar Chart
              Card(
                elevation: 2,
                child: SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxCount * 1.2,
                        barTouchData: BarTouchData(enabled: true),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < sortedCategories.length) {
                                  return Transform.rotate(
                                    angle: -0.3,
                                    child: Text(
                                      sortedCategories[index],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                              reservedSize: 60,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: _calculateInterval(maxCount),
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: 10),
                              ),
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(sortedCategories.length, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: sortedCounts[index].toDouble(),
                                color: Colors.green,
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),


              // 🔘 Elevated Button to Navigate to Chat
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (_) => ChatScreen(chartData: summary),
              //         ),
              //       );
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
              // List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Category-wise Product Count",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: sortedCategories.length,
                          itemBuilder: (context, index) {
                            final category = sortedCategories[index];
                            final count = sortedCounts[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  category,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                trailing: Text(
                                  "$count products",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
