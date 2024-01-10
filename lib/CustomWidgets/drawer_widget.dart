import 'dart:io';

import 'package:legalassistance/Packages/packages.dart';

showDrawer(BuildContext context, bool lawyer) {
  return Drawer(
    backgroundColor: appBarColor,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: appBarColor),
          child: Image.asset(
            'assets/logos/lawyerlogotransparent.png',
          ),
        ),
        drawerTile('assets/drawer/account.svg',
            LocalesData.drawerSignUP.getString(context), () {}),
        drawerTile(
          'assets/drawer/chat.svg',
          LocalesData.allChats.getString(context),
          () {
            screenFunction.nextScreen(
              context,
              const AllChatScreen(),
            );
          },
        ),
        drawerTile('assets/drawer/darkmode.svg',
            LocalesData.drawerDarkMode.getString(context), () {}),
        drawerTile('assets/drawer/languages.svg',
            LocalesData.drawerLanguages.getString(context), () {}),
        drawerTile('assets/drawer/aboutus.svg',
            LocalesData.drawerAboutUs.getString(context), () {}),
        drawerTile('assets/drawer/rateus.svg',
            LocalesData.drawerRateUs.getString(context), () {}),
        drawerTile('assets/drawer/forgetpass.svg',
            LocalesData.drawerForgetPass.getString(context), () {}),
        lawyer
            ? drawerTile('assets/drawer/upgradeprofile.svg',
                LocalesData.drawerUpdateProfile.getString(context), () {
                screenFunction.nextScreen(
                  context,
                  ProfileCompletionScreen(),
                );
              })
            : Container(),
        drawerTile('assets/drawer/logout.svg',
            LocalesData.drawerLogout.getString(context), () async {
          await FirebaseAuth.instance.signOut();
          screenFunction.nextScreen(
            context,
            LoginScreen(
              guestLoginTry: false,
            ),
          );
        }),
        // Add more ListTile widgets for additional items
      ],
    ),
  );
}
