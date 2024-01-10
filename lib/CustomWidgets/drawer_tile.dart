import 'package:legalassistance/Packages/packages.dart';

Widget drawerTile(String imagePath, String tileTitle, Function()? onTap) {
  return ListTile(
    tileColor: appBarColor,
    leading: SvgPicture.asset(
      imagePath,
      height: 20,
      color: Colors.white,
    ),
    title: Text(
      tileTitle,
      style: drawerStyle,
    ),
    onTap: onTap,
  );
}
