import 'package:legalassistance/Packages/packages.dart';

void showLayManPopup(
    BuildContext context, Function()? signUpOnTap, Function()? loginOnTap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: SizedBox(
            width: 350,
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                    'Please SignUp / Login first to access this feature'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: signUpOnTap,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xff1A2659).withOpacity(0.1),
                          ),
                          alignment: Alignment.center,
                          height: 40,
                          width: 100,
                          child: const Text('Sign up'),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: loginOnTap,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xff27104E)),
                        alignment: Alignment.center,
                        height: 40,
                        width: 100,
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
    },
  );
}
