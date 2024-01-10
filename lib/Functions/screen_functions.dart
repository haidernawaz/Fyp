import 'package:legalassistance/Packages/packages.dart';

class ScreenFunction {
  nextScreen(BuildContext context, screenName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screenName),
    );
  }

  popScreen(BuildContext context) {
    Navigator.pop(context);
  }
}
