// import 'package:flutter/material.dart';
// import 'package:fyp/mdemo.dart';
// import 'package:fyp/view/dashboard_screen.dart';
// import 'package:fyp/view/input_screen.dart';
// import 'package:fyp/view/invoice_screen.dart';
// import 'package:fyp/view/upload_image.dart';
// import 'package:fyp/Utils/colors.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         title: Text(
//           "FinScribe",
//           style: TextStyle(
//             color: AppColors.text,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => UploadImageScreen()),
//                 );
//               },
//               child: Container(
//                 width: 200,
//                 padding: EdgeInsets.all(16),
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: AppColors.text,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Select Image",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => InputScreen()),
//                 );
//               },
//               child: Container(
//                 width: 200,
//                 padding: EdgeInsets.all(16),
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: AppColors.text,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Manually Input",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => InvoiceScreen()),
//                 );
//               },
//               child: Container(
//                 width: 200,
//                 padding: EdgeInsets.all(16),
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: AppColors.text,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Invoice Screen",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DashboardScreen()),
//                 );
//               },
//               child: Container(
//                 width: 200,
//                 padding: EdgeInsets.all(16),
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: AppColors.text,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Dashboard Screen",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//



import 'package:flutter/material.dart';
import 'package:fyp/view/dashboard_screen.dart';
import 'package:fyp/view/input_screen.dart';
import 'package:fyp/view/invoice_screen.dart';
import 'package:fyp/view/upload_image.dart';
import 'package:fyp/Utils/components/colors.dart';

import '../mdemo.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          "FinScribe",
          style: TextStyle(
            color: AppColors.background2,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 16,
              // alignment: WrapAlignment.center,
              children: [
                _homeCard(
                  w,
                  h,
                  title: "Select Image",
                  icon: Icons.image_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UploadImageScreen()),
                  ),
                ),
                _homeCard(
                  w,
                  h,
                  title: "Manually Input",
                  icon: Icons.edit_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InputScreen()),
                  ),
                ),
                _homeCard(
                  w,
                  h,
                  title: "Invoice Screen",
                  icon: Icons.receipt_long_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => InvoiceScreen()),
                  ),
                ),
                _homeCard(
                  w,
                  h,
                  title: "Dashboard Screen",
                  icon: Icons.dashboard_customize_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () async {
              final authService = AuthService();
              await authService.logout(context);
            },
            child: Container(
              child: Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeCard(
      double w,
      double h, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.42,
        height: h * 0.18,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF399d4e), Color(0xFF25fcb5)],
            // colors: [Color(0xFF17A2B8), Color(0xFF20C997),],
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
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
