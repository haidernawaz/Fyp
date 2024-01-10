import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:legalassistance/Packages/packages.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.guestLoginTry}) : super(key: key);
  bool guestLoginTry = false;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  void _loginButtonPressed() {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide your phone number'),
        ),
      );
    } else if (phoneController.text.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kindly provide valid phone number'),
        ),
      );
    } else {
      String formattedPhoneNumber =
          phoneController.text.substring(1, phoneController.text.length);
      setState(() {
        loading = true;
      });
      auth.verifyPhoneNumber(
          phoneNumber: '+92$formattedPhoneNumber',
          verificationCompleted: (_) {},
          verificationFailed: (e) {
            if (kDebugMode) {
              print(e.toString());
            }
          },
          codeSent: (String verificationId, int? token) {
            setState(() {
              loading = false;
            });
            screenFunction.nextScreen(
                context,
                OtpScreen(
                  verificationId: verificationId,
                ));
          },
          codeAutoRetrievalTimeout: (e) {
            setState(() {
              loading = false;
            });
            if (kDebugMode) {
              print(e.toString());
            }
          });
    }
  }

  void _registerButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (widget.guestLoginTry) {
          return true;
        } else {
          bool exit1 = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return showExitPopup(context);
            },
          );

          if (exit1 == true) {
            exit(0);
          }
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xff6437A0),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logos/lawyerlogotransparent.png',
                filterQuality: FilterQuality.high,
                height: h * 0.35,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Unlock Legal Insight: Your Gateway to Informed Decision-Making',
                            style: GoogleFonts.eczar(
                                fontSize: 15, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle:
                                const TextStyle(color: Color(0xFF64379F)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF27104E),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF27104E),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _loginButtonPressed,
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xff27104E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: loading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: GoogleFonts.eczar(
                                        fontSize: 15, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _registerButtonPressed();
                          },
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: const TextSpan(
                                text: "Don’t have an Account? ",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "Register Now",
                                    style: TextStyle(
                                        color: Color(0xFF27104E),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        guestEntry: true,
                                      )),
                            );
                          },
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: RichText(
                              text: const TextSpan(
                                text: "Continue as ",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "Guest",
                                    style: TextStyle(
                                        color: Color(0xFF27104E),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
