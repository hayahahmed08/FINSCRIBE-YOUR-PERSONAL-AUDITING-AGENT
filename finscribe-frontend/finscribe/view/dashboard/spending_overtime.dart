import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../chat_analysis_button.dart';
import '../../mdemo.dart';
import '../../model/invoice_model.dart';
import '../../services/invoice_services.dart';
import '../../Utils/components/colors.dart';

class SpendingChart extends StatefulWidget {
  @override
  _SpendingChartState createState() => _SpendingChartState();
}

class _SpendingChartState extends State<SpendingChart> {
  late Future<Map<String, double>> dailySpending;
  String selectedRange = 'All';
  bool isLineChart = true;
  bool hasNavigated = false;



  @override
  void initState() {
    super.initState();
    dailySpending = fetchDailySpending();
  }

  Future<Map<String, double>> fetchDailySpending() async {
    try {
      List<Invoice> invoices = await InvoiceService().fetchInvoices();
      Map<String, double> spendingMap = {};
      final now = DateTime.now();

      for (var invoice in invoices) {
        try {
          final invoiceDate = DateFormat('MM/dd/yyyy').parse(invoice.invoiceDate);
          final dateKey = DateFormat('MM/dd/yyyy').format(invoiceDate);

          // Apply filter
          if (selectedRange == '7 days' && invoiceDate.isBefore(now.subtract(Duration(days: 7)))) {
            continue;
          } else if (selectedRange == '30 days' && invoiceDate.isBefore(now.subtract(Duration(days: 30)))) {
            continue;
          }

          spendingMap.update(
            dateKey,
                (value) => value + invoice.invoiceSummary.totalPrice,
            ifAbsent: () => invoice.invoiceSummary.totalPrice,
          );
        } catch (e) {
          print("Error parsing date: ${invoice.invoiceDate}");
        }
      }

      return spendingMap;
    } catch (e) {
      print('Error fetching daily spending: $e');
      throw Exception('Failed to fetch daily spending');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        title: Text(
          "Spending Over Time",
          style: TextStyle(
            color: AppColors.background2,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isLineChart ? Icons.bar_chart : Icons.show_chart, color: AppColors.background),
            onPressed: () {
              setState(() {
                isLineChart = !isLineChart;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Dropdown for filtering
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: DropdownButton<String>(
          //     value: selectedRange,
          //     items: ['All', '30 days', '7 days']
          //         .map((range) => DropdownMenuItem<String>(
          //       value: range,
          //       child: Text(range),
          //     ))
          //         .toList(),
          //     onChanged: (val) {
          //       setState(() {
          //         selectedRange = val!;
          //         dailySpending = fetchDailySpending();
          //       });
          //     },
          //   ),
          // ),
          Expanded(
            child: FutureBuilder<Map<String, double>>(
              future: dailySpending,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));

                final data = snapshot.data!;
                // if (!hasNavigated) {
                //   hasNavigated = true;
                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => ChatScreen(chartData: data),
                //       ),
                //     );
                //   });
                // }

                // return Center(child: Text('Redirecting to chat...'));

                final sortedKeys = data.keys.toList()..sort();
                final values = sortedKeys.map((key) => data[key]!).toList();

                double totalSpending = values.fold(0, (a, b) => a + b);
                double averageSpending = values.isNotEmpty ? totalSpending / values.length : 0;
                double maxSpending = values.isNotEmpty ? values.reduce(max) : 0;

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Summary
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSummaryTile("Total", totalSpending),
                              _buildSummaryTile("Avg", averageSpending),
                              _buildSummaryTile("Max", maxSpending),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Chart Card
                      Expanded(
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: isLineChart
                                ? LineChart(_buildLineChartData(sortedKeys, values))
                                : BarChart(_buildBarChartData(sortedKeys, values)),
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => ChatScreen(chartData: data),
                      //       ),
                      //     );
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: AppColors.appbarColor,
                      //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      //   ),
                      //   child: Text("Ask about this chart", style: TextStyle(color: Colors.white)),
                      // ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ChatAnalysisButton(),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTile(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        SizedBox(height: 4),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  LineChartData _buildLineChartData(List<String> sortedKeys, List<double> values) {
    return LineChartData(
      minY: 0,
      maxY: (values.reduce(max) * 1.2).ceilToDouble(),
      titlesData: _buildTitlesData(sortedKeys, values),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            sortedKeys.length,
                (i) => FlSpot(i.toDouble(), values[i]),
          ),
          isCurved: true,
          gradient: LinearGradient(colors: [Colors.green, Colors.orange]),
          barWidth: 3,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  BarChartData _buildBarChartData(List<String> sortedKeys, List<double> values) {
    return BarChartData(
      maxY: (values.reduce(max) * 1.2).ceilToDouble(),
      titlesData: _buildTitlesData(sortedKeys, values),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(
        values.length,
            (i) => BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: values[i], width: 12, color: Colors.blue),
        ]),
      ),
    );
  }

  FlTitlesData _buildTitlesData(List<String> sortedKeys, List<double> values) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: (values.reduce(max) / 5).ceilToDouble(),
          getTitlesWidget: (value, _) {
            if (value >= 1000) {
              return Text('\$${(value / 1000).toStringAsFixed(1)}K', style: TextStyle(fontSize: 10));
            }
            return Text('\$${value.toStringAsFixed(0)}', style: TextStyle(fontSize: 10));
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: (sortedKeys.length / 6).ceilToDouble(),
          getTitlesWidget: (value, _) {
            int index = value.toInt();
            if (index >= sortedKeys.length) return const SizedBox.shrink();
            final date = DateFormat('MM/dd').format(DateFormat('MM/dd/yyyy').parse(sortedKeys[index]));
            return Transform.rotate(
              angle: -0.0,
              child: Text(date, style: TextStyle(fontSize: 10)),
            );
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}