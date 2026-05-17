import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



// class FirebaseAuthMethods{
//   final FirebaseAuth _auth;
//   FirebaseAuthMethods(this._auth);
//
//   //Email Sign up
//
//   // Future<void> signUpWithEmail({
//   //   required String email,
//   //   required String password,
//   //   required BuildContext context,
//   // })async{
//   //   try{
//   //     await _auth.createUserWithEmailAndPassword(
//   //         email: email,
//   //         password: password
//   //     );
//   //     await sendEmailVerification(context);
//   //   }on FirebaseAuthException catch(e){
//   //     if(e.code == 'weak-password'){
//   //       showSnackBar(context,e.message!);
//   //     };
//   //     showSnackBar(context, e.message!);
//   //   }
//   // }
//
//   Future<bool> signUpWithEmail({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       await sendEmailVerification(context);
//       showSnackBar(context, 'Sign up successful. Please check your email for verification.');
//       return true;
//
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message ?? 'An error occurred');
//       return false;
//     }
//   }
//
//
//   //Email verification
//   Future<void>sendEmailVerification(BuildContext context)async{
//     try{
//       _auth.currentUser!.sendEmailVerification();
//       showSnackBar(context, 'Email verification sent!');
//     }on FirebaseAuthException catch(e){
//       showSnackBar(context, e.message!);
//     }
//   }
//
//
//   //Email Login
//   // Future<void>loginWithEmail({
//   //   required String email,
//   //   required String password,
//   //   required BuildContext context,
//   // })async{
//   //   try{
//   //     await _auth.signInWithEmailAndPassword(
//   //         email: email,
//   //         password: password
//   //     );
//   //     if(!_auth.currentUser!.emailVerified){
//   //       await sendEmailVerification(context);
//   //     }
//   //   }on FirebaseAuthException catch(e){
//   //     showSnackBar(context, e.message!);
//   //   }
//   // }
//
//
//   Future<bool> loginWithEmail({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // if (!_auth.currentUser!.emailVerified) {
//       //   await sendEmailVerification(context);
//       //   showSnackBar(context, 'Please verify your email before proceeding.');
//       //   return false;
//       // }
//
//       showSnackBar(context, 'Login Successfull');
//       return true; // Login successful
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message!);
//       return false; // Login failed
//     }
//   }
// }



import 'dart:convert';
import 'dart:async';
import 'package:fyp/model/login_response_model.dart';
import 'package:fyp/view/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/signup_response_model.dart';
import '../view/login_screen.dart';

class AuthService {
  final String baseUrl = 'https://data-digitization.vercel.app';

  // LOGIN
  Future<LoginResponseModel?> login(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'Mozilla/5.0 (Mobile; FlutterApp)',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      print('Login Response status: ${response.statusCode}');
      print('Login Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        //Chutiya Backend Hai  Tw Save the token in SharedPreferences
        final token = responseData['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return LoginResponseModel.fromJson(responseData);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }


  Future<SignupResponseModel?> signup(String email, String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password
        }),
      );

      print('Signup Response status: ${response.statusCode}');
      print('Signup Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);


        final token = responseData['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return SignupResponseModel.fromJson(responseData);
      } else {
        throw Exception('Signup failed: ${response.body}');
      }
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }


  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print('-----Logged out and token removed------');

    // Navigate to login screen and clear the backstack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
