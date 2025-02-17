import 'dart:convert';
import 'package:dealsdray/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _addDevice();
  }

  Future<void> _addDevice() async {
    final url =
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add');

    // The JSON body
    final Map<String, dynamic> requestBody = {
      "deviceType": "android", 
      "deviceId": "C6179909526098",
      "deviceName": "Samsung-MT200",
      "deviceOSVersion": "2.3.6",
      "deviceIPAddress": "11.433.445.66",
      "lat": 9.9312,
      "long": 76.2673,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": "1.20.5",
        "installTimeStamp": "2022-02-10T12:33:30.696Z",
        "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
        "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final responseData = jsonDecode(response.body);
          debugPrint('Device added successfully: $responseData');

          // Extract deviceId from response
          String deviceId = responseData['data']['deviceId'];

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(deviceId: deviceId),
              ),
            );
          }
        }
      } else {
        // Handle error response
        debugPrint('Failed to add device. Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      debugPrint('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/lodingimg2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Loading indicator
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
