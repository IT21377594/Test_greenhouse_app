import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:greenhouse_app/pages/home_page.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  void _signin() async {
    String? token = await _authService.signin(
      _emailController.text,
      _passwordController.text,
    );

    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signin successful! Redirecting...")),
      );

      // Navigate to HomeScreen without passing token
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signin failed!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signin")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signin,
              child: Text("Signin"),
            ),
          ],
        ),
      ),
    );
  }
}

