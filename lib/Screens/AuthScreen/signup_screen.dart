import 'package:legalassistance/Packages/packages.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isLawyer = false;
  bool loading = false;
  final auth = FirebaseAuth.instance;
  void _signupButtonPressed() {
    if (firstNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
    } else if (phoneController.text.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kindly provide valid phone number'),
        ),
      );
    } else if (_containsDigits(firstNameController.text) ||
        _containsDigits(lastNameController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digits are not allowed in name section'),
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
            print(e.toString());
          },
          codeSent: (String verificationId, int? token) {
            setState(() {
              loading = false;
            });
            screenFunction.nextScreen(
                context,
                VerifyNumberScreen(
                  verificationId: verificationId,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: '+92$formattedPhoneNumber',
                  role: isLawyer ? 'lawyer' : 'layman',
                ));
          },
          codeAutoRetrievalTimeout: (e) {
            setState(() {
              loading = false;
            });
            print(e.toString());
          });
    }
  }

  bool _containsDigits(String value) {
    return value.runes.any((rune) => !isAlphabetic(rune));
  }

  bool isAlphabetic(int rune) {
    return (65 <= rune && rune <= 90) || (97 <= rune && rune <= 122);
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
                          'Unlock Legal Insight: Your Gateway to Informed Decision-Making',
                          style: GoogleFonts.eczar(
                              fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          hintText: 'First Name',
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
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
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
                      TextField(
                        controller: phoneController,
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
                      Row(
                        children: [
                          Radio(
                            value: false,
                            groupValue: isLawyer,
                            onChanged: (value) {
                              setState(() {
                                isLawyer = value as bool;
                              });
                            },
                          ),
                          const Text(
                            'Layman',
                            style: TextStyle(
                              color: Color(0xFF27104E),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Radio(
                            value: true,
                            groupValue: isLawyer,
                            onChanged: (value) {
                              setState(() {
                                isLawyer = value as bool;
                              });
                            },
                          ),
                          const Text(
                            'Lawyer',
                            style: TextStyle(
                              color: Color(0xFF27104E),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                                  'Signup',
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
