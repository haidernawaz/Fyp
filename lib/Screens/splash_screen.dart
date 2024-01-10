import 'package:legalassistance/Packages/packages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        if (auth.currentUser != null) {
          screenFunction.nextScreen(context, HomeScreen(guestEntry: false));
        } else {
          screenFunction.nextScreen(
              context,
              LoginScreen(
                guestLoginTry: false,
              ));
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Image.asset('assets/logos/lawyerlogo.png'),
        ),
      ),
    );
  }
}
