import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import '../Utils/components/colors.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool _isLoading = false;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    // Pick image from gallery
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await uploadImage(
      imageFile: _image!,
      context: context,
      fieldName: 'files',
      endpoint: 'https://data-digitization.vercel.app/receipts/upload',
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        centerTitle: true,
        title: Text(
          "Upload Image",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: _image == null
                              ? Center(
                            child: Text(
                              "No image selected",
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          )
                              : Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        if (_image != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage, // how can i give _pickImage in this
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.appbarColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Select Image from Gallery",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _isLoading ? null : () => _uploadImage(context),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.appbarColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Upload Image",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Future<void> uploadImage({required File imageFile,required BuildContext context, required String fieldName, required String endpoint,}) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token'); // your saved login token
//
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No auth token found. Please log in.")),
//       );
//       return;
//     }
//
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse(endpoint),
//     );
//
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         fieldName,
//         imageFile.path,
//         contentType: MediaType('image', path.extension(imageFile.path).replaceAll('.', '')),
//       ),
//     );
//
//     request.headers.addAll({
//       'Authorization': 'Bearer $token',
//     });
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 200) {
//       print("Image uploaded successfully!");
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text("Image uploaded successfully!")),
//       // );
//     } else {
//       print("Failed to upload image: ${response.statusCode}\n${response.body}");
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text("Failed to upload image: ${response.statusCode}\n${response.body}")),
//       // );
//     }
//   } catch (e) {
//     print("Upload failed: $e");
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   SnackBar(content: Text("An error occurred: $e")),
//     // );
//   }
// }



Future<void> uploadImage({
  required File imageFile,
  required BuildContext context,
  required String fieldName,
  required String endpoint,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // your saved login token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No auth token found. Please log in.")),
      );
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        fieldName,
        imageFile.path,
        contentType: MediaType('image', path.extension(imageFile.path).replaceAll('.', '')),
      ),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // ✅ Show Alert Dialog on successful upload
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text("Image uploaded successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      print("Failed to upload image: ${response.statusCode}\n${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image.")),
      );
    }
  } catch (e) {
    print("Upload failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: $e")),
    );
  }
}
