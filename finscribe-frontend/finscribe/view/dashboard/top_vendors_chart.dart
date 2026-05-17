import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../chat_analysis_button.dart';
import '../../mdemo.dart';
import '../../model/invoice_model.dart';
import '../../services/invoice_services.dart';
import '../../Utils/components/colors.dart';

class TopVendorChart extends StatefulWidget {
  @override
  _TopVendorChartState createState() => _TopVendorChartState();
}

class _TopVendorChartState extends State<TopVendorChart> {
  late Future<Map<String, int>> vendorFrequency;
  bool hasNavigated = false;


  @override
  void initState() {
    super.initState();
    vendorFrequency = fetchVendorFrequency();
  }

  Future<Map<String, int>> fetchVendorFrequency() async {
    try {
      List<Invoice> invoices = await InvoiceService().fetchInvoices();

      Map<String, int> frequencyMap = {};
      for (var invoice in invoices) {
        String vendor = invoice.vendorName.trim();
        if (vendor.isEmpty) continue;

        frequencyMap.update(vendor, (value) => value + 1, ifAbsent: () => 1);
      }

      return frequencyMap;
    } catch (e) {
      print('Error fetching vendor frequency: $e');
      throw Exception('Failed to fetch vendor frequency');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        title: Text(
          "Top Vendors",
          style: TextStyle(
            color: AppColors.background2,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            elevation: 2,
            child: FutureBuilder<Map<String, int>>(
              future: vendorFrequency,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));

                final data = snapshot.data!;
                final vendors = data.keys.toList();
                final counts = data.values.toList();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(enabled: true),
                        alignment: BarChartAlignment.center,
                        maxY: (counts.reduce((a, b) => a > b ? a : b).toDouble() + 1),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, interval: 1),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                if (value.toInt() >= vendors.length) return SizedBox.shrink();

                                final fullName = vendors[value.toInt()];
                                final maxChars = 10;
                                final displayName = fullName.length > maxChars
                                    ? '${fullName.substring(0, maxChars)}…'
                                    : fullName;

                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('Vendor'),
                                        content: Text(fullName),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Transform.rotate(
                                      angle: -0.4, // ~ -45 degrees
                                      child: Text(
                                        displayName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(vendors.length, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: counts[index].toDouble(),
                                color: AppColors.text,
                                width: 18,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ChatAnalysisButton(),
          ),
          Text(
            'Top Vendors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          FutureBuilder<Map<String, int>>(
            future: vendorFrequency,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));

              final data = snapshot.data!;
              final sortedVendors = data.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              // return Expanded(
              //   child: ListView.builder(
              //     itemCount: sortedVendors.length,
              //     itemBuilder: (context, index) {
              //       final vendor = sortedVendors[index];
              //       return Card(
              //         elevation: 2,
              //         child: ListTile(
              //           title: Text(vendor.key),
              //           trailing: Text(vendor.value.toString()),
              //         ),
              //       );
              //     },
              //   ),
              // );

              return Expanded(
                child: FutureBuilder<Map<String, int>>(
                  future: vendorFrequency,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final data = snapshot.data!;
                    final sortedVendors = data.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));

                    return ListView.builder(
                      itemCount: sortedVendors.length,
                      itemBuilder: (context, index) {
                        final vendor = sortedVendors[index];
                        return Card(
                          elevation: 2,
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
                            title: Text(vendor.key),
                            trailing: Text(
                              vendor.value.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          // SizedBox(height: 24),

          // ElevatedButton(
          //   onPressed: () async {
          //     final data = await vendorFrequency;
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
        ],
      ),
    );
  }
}