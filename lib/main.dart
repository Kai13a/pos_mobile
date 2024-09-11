// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import "package:flutter/material.dart";
import 'package:pos_mobile/cashierPage.dart';
import 'package:pos_mobile/colorPalette.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorPalette.color1,
        body: Center(
          child: Loginfield(),
        ),
      ),
    );
  }
}

class Loginfield extends StatefulWidget {
  const Loginfield({super.key});

  @override
  State<Loginfield> createState() => _Loginfield();
}

class _Loginfield extends State<Loginfield> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  bool _obscureText = true;

  Future<void> login(String username, String password) async {
    final url = Uri.parse('http://*IP-Address*:3000/api/login/');//Add own IP Address
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Successful login
      final data = jsonDecode(response.body);
      String token = data['token'];

      // Saved token using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const cashierPage()));
    } else {
      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
      });
    }
  }

  //For password toggle

  //@override
  //void dispose() {
  //  _passwordField.dispose();
  //  super.dispose();
  //}

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Icon(
            Icons.circle_rounded,
            size: 150,
            color: ColorPalette.color4,
          ),
        ),
        const SizedBox(height: 0),
        const Center(
          child: Text(
            "Joreb's Company",
            style: TextStyle(
              color: ColorPalette.color4,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 80),
        Container(
          width: 325,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _emailField,
            decoration: InputDecoration(
              labelText: 'Username',
              filled: true,
              fillColor: ColorPalette.color4,
              prefixIcon: const Icon(Icons.account_circle_outlined, size: 30),
              border: 
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  // Change border color here
                  color: ColorPalette
                      .color1, // Adjust to your desired border color
                  width: 2.0, // Adjust to your desired border width
                ),
              ),
            ),
            style: const TextStyle(color: ColorPalette.color1),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 325,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _passwordField,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: ColorPalette.color4,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                size: 30,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  size: 24,
                ),
                onPressed: _togglePasswordVisibility,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
            obscureText: _obscureText,
            style: const TextStyle(color: ColorPalette.color1),
          ),
        ),
        const SizedBox(height: 80),
        _isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.buttonBG,
                  ),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = '';
                    });

                    await login(_emailField.text, _passwordField.text);

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(color: ColorPalette.color4),
                  ),
                ),
              ),
        const SizedBox(height: 10),
        if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
