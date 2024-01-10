import 'package:legalassistance/Packages/packages.dart';

showAppBar(BuildContext context, String title) {
  return AppBar(
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
    elevation: 0,
    backgroundColor: appBarColor,
    title: Text(
      title,
      style: appBarStyle,
    ),
  );
}
