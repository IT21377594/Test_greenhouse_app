import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://100.103.95.80:8000/auth";

  // Store token and user details after successful signup or signin
  Future<void> storeUserData(String token, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_name', name); // Store user name
    await prefs.setString('user_email', email);
  }

  // Get stored user data (use this in HomePage)
  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('user_name');
    String? email = prefs.getString('user_email');
    return {
      'name': name ?? 'User',
      'email': email ?? '',
    };
  }

  Future<bool> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var token = responseData["token"];
      var returnedName = responseData["name"]; // Name returned from backend

      if (token != null && returnedName != null) {
        await storeUserData(token, returnedName, email); // Save token and name
        return true;
      } else {
        throw Exception("Invalid response data: token or name is missing.");
      }
    }
    return false;
  }

  Future<String?> signin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      var token = jsonDecode(response.body)["token"];
      var name =
          jsonDecode(response.body)["name"]; // Retrieve name from response
      await storeUserData(
          token, name, email); // Store name in SharedPreferences
      return token;
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
  }
}