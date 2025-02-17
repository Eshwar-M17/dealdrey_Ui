import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dealsdray/screens/home_screen.dart';


class SignupPage extends StatefulWidget {
  final String userId; 

  const SignupPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  Future<void> signupUser() async {
    // If referral is empty, pass empty string, otherwise pass the trimmed text.
    final String referralValue = _referralController.text.trim().isEmpty
        ? ""
        : _referralController.text.trim();

    final Map<String, dynamic> body = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "referralCode": referralValue,
      "userId": widget.userId,
    };

    final Uri url =
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/email/referral");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint('Signup successful: ${response.body}');
        final jsonData = jsonDecode(response.body);

        // Check if the response indicates a success
        if (jsonData['status'] == 1) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonData['message'] ?? 'Signup failed.'),
            ),
          );
        }
      } else {
        debugPrint('Failed to signup. Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup failed. Please try again.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: ElevatedButton(
          onPressed: signupUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.zero,
           
          ),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      ),

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 20),

            // Heading
            const Text(
              "Let's Begin!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Subtext
            const Text(
              "Please enter your credentials to proceed",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Email
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black87),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Your Email',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Password
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.black87),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Create Password',
                labelStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(Icons.visibility),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Referral Code (Optional)
            TextField(
              controller: _referralController,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                labelText: 'Referral Code (Optional)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}
