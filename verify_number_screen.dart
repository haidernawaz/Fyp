import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legalassistance/Packages/packages.dart';

class VerifyNumberScreen extends StatefulWidget {
  String verificationId;
  String firstName;
  String lastName;
  String phoneNumber;
  String role;
  VerifyNumberScreen(
      {super.key,
      required this.verificationId,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.role});

  @override
  State<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  TextEditingController otpController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  void _signupButtonPressed() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill OTP field'),
        ),
      );
    } else {
      setState(() {
        loading = true;
      });
      final credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otpController.text.toString());
      try {
        setState(() {
          loading = false;
        });
        await auth.signInWithCredential(credential);
        var uId = auth.currentUser!.uid;
        FirebaseFirestore.instance.collection('users').doc(uId).set({
          'firstname': widget.firstName,
          'lastname': widget.lastName,
          'phoneNumber': widget.phoneNumber,
          'role': widget.role
        });

        screenFunction.nextScreen(
          context,
          HomeScreen(guestEntry: false),
        );
      } catch (e) {
        setState(() {
          loading = false;
        });
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please provide valid otp'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
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
                          'Write Your 6 Digit OTP Code',
                          style: GoogleFonts.eczar(
                              fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: const TextStyle(color: Color(0xFF64379F)),
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
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _signupButtonPressed,
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
                                  'Verify',
                                  style: GoogleFonts.eczar(
                                      fontSize: 15, color: Colors.white),
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
    );
  }
}
