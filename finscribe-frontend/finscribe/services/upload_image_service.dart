// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:mime/mime.dart';
// import 'package:path/path.dart';
//
// class ImageUploadService {
//   final String _uploadUrl = 'https://your-api.com/upload'; // Replace with actual endpoint
//
//   Future<bool> uploadImage(File imageFile, String accessToken) async {
//     try {
//       final mimeTypeData = lookupMimeType(imageFile.path)!.split('/');
//
//       final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(_uploadUrl))
//         ..headers.addAll({
//           'Authorization': 'Bearer $accessToken',
//         })
//         ..files.add(await http.MultipartFile.fromPath(
//           'file',
//           imageFile.path,
//           contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
//           filename: basename(imageFile.path),
//         ));
//
//       final streamedResponse = await imageUploadRequest.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         print("Upload success: ${response.body}");
//         return true;
//       } else {
//         print("Upload failed: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//       return false;
//     }
//   }
// }
