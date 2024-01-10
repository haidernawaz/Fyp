import 'package:legalassistance/Packages/packages.dart';

List<MapLocale> LOCALES = [
  MapLocale('en', LocalesData.EN),
];
mixin LocalesData {
  static const String appbar = 'homeTitle';
  static const String drawerSignUP = 'drawerSignUP';
  static const String drawerDarkMode = 'drawerDarkMode';
  static const String drawerLanguages = 'drawerLanguages';
  static const String drawerAboutUs = 'drawerAboutUs';
  static const String drawerRateUs = 'drawerRateUs';
  static const String drawerForgetPass = 'drawerForgetPass';
  static const String drawerUpdateProfile = 'drawerUpdateProfile';
  static const String drawerLogout = 'drawerLogout';
  static const String homeAsk = 'homeAsk';
  static const String todayNews = 'todayNews';
  static const String books = 'books';
  static const String askQuery = 'askQuery';
  static const String recommendedLayers = 'recommendedLayers';
  static const String allChats = 'allChats';
  static const Map<String, dynamic> EN = {
    appbar: 'LEGAL ASSISTANCE',
    drawerSignUP: 'Sign Up',
    drawerDarkMode: 'Dark Mode',
    drawerLanguages: 'Languages',
    drawerAboutUs: 'About Us',
    drawerRateUs: 'Rate Us',
    drawerForgetPass: 'Forget Password',
    drawerUpdateProfile: 'Update Profile',
    drawerLogout: 'Logout',
    homeAsk: 'Ask Your Query',
    todayNews: 'Today News',
    books: 'Books',
    askQuery: 'Write your query',
    recommendedLayers: 'Recommended Lawyers',
    allChats: 'All Chats'
  };
  static const Map<String, dynamic> UR = {};
}
