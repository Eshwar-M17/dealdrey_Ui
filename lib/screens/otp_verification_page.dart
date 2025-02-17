import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dealsdray/screens/register_page.dart';
import 'package:dealsdray/screens/home_screen.dart';
class OtpVerificationScreen extends StatefulWidget {
  final String deviceId;
  final String userId;
  final String mobileNumber; 
  const OtpVerificationScreen({
    Key? key,
    required this.deviceId,
    required this.userId,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Controllers for the 4 OTP fields (assuming 4 digits for simplicity)
  final TextEditingController _otp1Controller = TextEditingController();
  final TextEditingController _otp2Controller = TextEditingController();
  final TextEditingController _otp3Controller = TextEditingController();
  final TextEditingController _otp4Controller = TextEditingController();

  // Timer related
  late Timer _timer;
  int _start = 117; // 1 minute 57 seconds = 117 seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start <= 0) {
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Format seconds into mm:ss
  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    String minuteString = minutes.toString().padLeft(2, '0');
    String secondString = seconds.toString().padLeft(2, '0');
    return '$minuteString : $secondString';
  }

  @override
  void dispose() {
    _timer.cancel();
    _otp1Controller.dispose();
    _otp2Controller.dispose();
    _otp3Controller.dispose();
    _otp4Controller.dispose();
    super.dispose();
  }

  // Helper to build OTP text field box
  Widget _buildOtpBox(TextEditingController controller) {
    return SizedBox(
      width: 45,
      height: 45,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '', // hides the counter (0/1)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  // Function to call OTP Verification API
  Future<void> verifyOtpApi(String otpCode) async {
    final Uri url =
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp/verification");
    final Map<String, dynamic> body = {
      "otp": otpCode,
      "deviceId": widget.deviceId,
      "userId": widget.userId,
    };
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("OTP verified successfully");
        debugPrint("Response body: ${response.body}");
        final jsonResponse = jsonDecode(response.body);
        // Check registration_status
        if (jsonResponse["data"]["registration_status"] == "Incomplete") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignupPage(userId: widget.userId),
            ),
          );
        } else {
          debugPrint("Registration is complete. Navigate to HomeScreen.");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } else {
        debugPrint(
            "OTP verification failed. Status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("OTP verification failed. Please try again.")),
        );
      }
    } catch (e) {
      debugPrint("Exception occurred during OTP verification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top icon (phone with bubble)
                  Image.asset(
                    "assets/images/otp.png",
                    height: 120,
                  ),
                  const SizedBox(height: 24),
                  // Heading
                  const Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We have sent a unique OTP to your mobile ${widget.mobileNumber}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  // OTP fields in a row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOtpBox(_otp1Controller),
                      _buildOtpBox(_otp2Controller),
                      _buildOtpBox(_otp3Controller),
                      _buildOtpBox(_otp4Controller),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timerText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 40),
                      TextButton(
                        onPressed: () {
                        
                          setState(() {
                            _start = 117; // reset to 1:57
                          });
                        },
                        child: const Text(
                          'SEND AGAIN',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final otpCode = _otp1Controller.text +
                            _otp2Controller.text +
                            _otp3Controller.text +
                            _otp4Controller.text;
                        if (otpCode.length < 4) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please enter the complete OTP.")),
                          );
                          return;
                        }
                        debugPrint('OTP Entered: $otpCode');
                        verifyOtpApi(otpCode);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, 
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), 
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15), 
                      ),
                      child: const Text(
                        "VERIFY", 
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, 
                        ),
                      ),
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
