import 'package:legalassistance/Packages/packages.dart';

homeButton(
    Function()? onTap, String buttonTitle, double? height, double? width) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        alignment: Alignment.center,
        height: height! * 0.06,
        width: width! * 0.8,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                spreadRadius: 1.0,
                offset: Offset(2, 4))
          ],
          color: const Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          buttonTitle,
          style: homeTextStyle,
        ),
      ),
    ),
  );
}
