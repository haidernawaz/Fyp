import 'package:flutter/services.dart';
import 'package:legalassistance/Packages/packages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization flutterLocalization = FlutterLocalization.instance;
  @override
  void initState() {
    _configureLocalization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      supportedLocales: flutterLocalization.supportedLocales,
      localizationsDelegates: flutterLocalization.localizationsDelegates,
    );
  }

  _configureLocalization() {
    flutterLocalization.init(mapLocales: LOCALES, initLanguageCode: 'en');
    flutterLocalization.onTranslatedLanguage = onTranslateLanguage;
  }

  onTranslateLanguage(Locale? locale) {
    setState(() {});
  }
}
