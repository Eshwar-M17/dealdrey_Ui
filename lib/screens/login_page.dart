import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:dealsdray/screens/otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  final String deviceId;

  const LoginPage({Key? key, required this.deviceId}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<bool> isSelected = [true, false];
  final TextEditingController _phoneController = TextEditingController();

  Future<void> requestOtp(String phoneNumber) async {
    final Map<String, dynamic> body = {
      "mobileNumber": phoneNumber,
      "deviceId": widget.deviceId, // Using dynamic deviceId
    };

    final Uri url = Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String userId = responseData['data']['userId']; // Extract userId

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              deviceId: widget.deviceId,
              userId: userId,
              mobileNumber: phoneNumber,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
              content: Text('Failed to request OTP. Please try again.${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          children: [
            Center(
              child: Image.asset('assets/images/logo.png', height: 200),
            ),
            ToggleButtons(
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = (i == index);
                  }
                });
              },
              borderRadius: BorderRadius.circular(30),
              borderColor: Colors.white,
              selectedBorderColor: Colors.red,
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Colors.red,
              constraints: const BoxConstraints(minWidth: 100, minHeight: 40),
              children: const [
                Text('Phone',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Email'),
              ],
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Glad to see you!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isSelected[0]
                    ? "Please provide your phone number"
                    : "Please provide your email address",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.black87),
              keyboardType: isSelected[0]
                  ? TextInputType.phone
                  : TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: isSelected[0] ? 'Phone' : 'Email',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String phoneNumber = _phoneController.text.trim();
                  if (phoneNumber.isNotEmpty) {
                    requestOtp(phoneNumber);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please enter a phone number")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("SEND CODE",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
