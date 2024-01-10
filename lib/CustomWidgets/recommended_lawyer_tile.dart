import 'package:legalassistance/Packages/packages.dart';

showRecommendedLawyer(
    double width, double height, BuildContext context, Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      width: width * 0.8,
      height: height * 0.06,
      decoration: BoxDecoration(
        color: appBarColor!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        LocalesData.recommendedLayers.getString(context),
        style: GoogleFonts.eczar(
            fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
      ),
    ),
  );
}
