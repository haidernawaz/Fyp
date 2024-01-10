import 'package:legalassistance/Packages/packages.dart';

showExitPopup(BuildContext context) {
  return AlertDialog(
    title: const Text('Exit Confirmation'),
    content: const Text('Do you want to exit?'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: const Text('Yes'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text('No'),
      ),
    ],
  );
}
