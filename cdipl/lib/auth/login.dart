import 'package:cdipl/api/authservice.dart';
import 'package:cdipl/helpers/tokenmanager.dart';
import 'package:cdipl/home/home.dart';
import 'package:cdipl/main.dart';
import 'package:cdipl/providers/userprovider.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

// Define constants for colors
const Color loginButtonColor = Color.fromARGB(243, 45, 206, 118);
const Color errorBoxColor = Color(0xFFEB3B3B);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // Toggle password visibility
  String errorMessage = '';

  get http => null;

  Future<void> loginUser(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Employee ID and Password are required'),
        ),
      );
      return;
    }
    try {
      final data = await AuthApiService().login(username, password);
      final token =
          data['token']; // Adjust based on your actual response structure
      // final userdata =
      //     data['user']; // Adjust based on your actual response structure
      await TokenManager.setToken(token);

      // print(token);
      // Provider.of<UserProvider>(context, listen: false).setUser(userdata);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically

                crossAxisAlignment: CrossAxisAlignment
                    .center, // Ensure items are centered horizontally
                children: <Widget>[
                  SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: [
                        const Text(
                          'CDIPL',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Version 0.0.1',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                            height: 20), // Spacing between text and icon
                        // Company icon just below the text
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/3063/3063821.png',
                          width: 75,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50), // Extra space
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText:
                              _obscurePassword, // Obscure or show password based on toggle
                          decoration: InputDecoration(
                            labelText: 'Enter Password',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword =
                                      !_obscurePassword; // Toggle password visibility
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            String username = usernameController.text;
                            String password = passwordController.text;
                            loginUser(username, password);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            decoration: BoxDecoration(
                              color: loginButtonColor, // Use the constant color
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Center(
                              child: Text(
                                'Login Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
