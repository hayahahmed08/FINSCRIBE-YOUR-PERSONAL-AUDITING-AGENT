import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}


// import 'package:flutter/material.dart';
// import '../colors.dart';
//
// class CustomSnackbar {
//   static void show(
//       BuildContext context, {
//         required String message,
//         bool isSuccess = true,
//       }) {
//     final color = isSuccess ? AppColors.primary : AppColors.mutedRed;
//     final icon = isSuccess ? Icons.check_circle_outline : Icons.error_outline;
//
//     final snackBar = SnackBar(
//       backgroundColor: AppColors.lightGray,
//       behavior: SnackBarBehavior.floating,
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       content: Row(
//         children: [
//           Icon(
//             icon,
//             color: color,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               message,
//               style: TextStyle(
//                 color: AppColors.darkGray,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
