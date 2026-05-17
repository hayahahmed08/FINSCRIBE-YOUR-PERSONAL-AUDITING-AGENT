// import 'package:flutter/material.dart';
// import 'package:fyp/Utils/dashboard/product_summary_screen.dart';
// import 'package:fyp/Utils/dashboard/top_vendors_chart.dart';
// import '../Utils/colors.dart';
// import '../Utils/dashboard/product_category_vs_total_spending.dart';
// import '../Utils/dashboard/spending_overtime.dart';
// import '../Utils/components/pie_chart.dart';
//
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//
//     Widget iconWithOptionalGradient(IconData iconData) {
//       return Icon(
//         iconData,
//         color: Colors.white,
//         size: 28,
//       );
//
//       // Uncomment below if you want gradient-colored icons instead:
//       /*
//       return ShaderMask(
//         shaderCallback: (bounds) => LinearGradient(
//           colors: [Colors.cyan, Colors.blueAccent],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ).createShader(bounds),
//         child: Icon(
//           iconData,
//           color: Colors.white,
//           size: 28,
//         ),
//       );
//       */
//     }
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         title: const Text(
//           "Dashboard",
//           style: TextStyle(
//             color: AppColors.text,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 dashboardCard(
//                   w,
//                   h,
//                   labelLines: ["Spending", "Overtime"],
//                   icon: iconWithOptionalGradient(Icons.payments_outlined),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => SpendingChart()),
//                     );
//                   },
//                 ),
//                 dashboardCard(
//                   w,
//                   h,
//                   labelLines: ["Top Vendors"],
//                   icon: iconWithOptionalGradient(Icons.store_mall_directory_outlined),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => TopVendorChart()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 dashboardCard(
//                   w,
//                   h,
//                   labelLines: ["Product Level", "Insights"],
//                   icon: iconWithOptionalGradient(Icons.analytics_outlined),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => ProductLevelInsights()),
//                     );
//                   },
//                 ),
//                 dashboardCard(
//                   w,
//                   h,
//                   labelLines: ["Product Category", "vs", "Total Spending"],
//                   icon: iconWithOptionalGradient(Icons.sort),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => ProductCategoryVsTotalSpending()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget dashboardCard(
//       double w,
//       double h, {
//         required List<String> labelLines,
//         required Widget icon,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: w * 0.45,
//         height: h * 0.17,
//         padding: const EdgeInsets.all(16),
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: AppColors.text,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ...labelLines.map((text) => Text(
//                 text,
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//                 textAlign: TextAlign.center,
//               )),
//               const SizedBox(height: 8),
//               icon,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../Utils/components/colors.dart';
import 'dashboard/product_category_vs_total_spending.dart';
import 'dashboard/product_summary_screen.dart';
import 'dashboard/spending_overtime.dart';
import 'dashboard/top_vendors_chart.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: AppColors.background2,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Wrap(
            runSpacing: 16,
            spacing: 16,
            children: [
              dashboardCard(
                w,
                h,
                title: ["Spending", "Overtime"],
                icon: Icons.payments_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SpendingChart()),
                ), textSize: 14.0,
              ),
              dashboardCard(
                w,
                h,
                title: ["Top Vendors"],
                icon: Icons.store_mall_directory_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TopVendorChart()),
                ), textSize: 14.0,
              ),
              dashboardCard(
                w,
                h,
                title: ["Product Level", "Insights"],
                icon: Icons.analytics_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductLevelInsights()),
                ), textSize: 14.0,
              ),
              dashboardCard(
                w,
                h,
                title: ["Product Category", "vs", "Total Spending"],
                icon: Icons.sort,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductCategoryVsTotalSpending()),
                ), textSize: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardCard(
      double w,
      double h, {
        required List<String> title,
        required IconData icon,
        required VoidCallback onTap,
        required textSize,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.42,
        height: h * 0.18,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF399d4e), Color(0xFF25fcb5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Colors.white70],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: Icon(
                icon,
                size: 45,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: title
                    .map(
                      (line) => Text(
                    line,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize, // slightly reduced font size
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.center,
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
