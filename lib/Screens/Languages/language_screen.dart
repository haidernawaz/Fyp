import 'package:legalassistance/Packages/packages.dart';

class LanguageScreen extends StatefulWidget {
  LanguageScreen({
    super.key,
  });

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int _currentIndex = -1;
  String? value;
  late FlutterLocalization _flutterLocalization;
  List languages = ['English', 'Urdu'];
  late String? _currentLocale;
  List<String> languageCodes = ['en', 'ur'];

  @override
  void initState() {
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    print(_currentLocale);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: languages.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                        value = languageCodes[index];
                        _currentLocale = value;
                        _setLocale(value);
                      });
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: languageCodes[index] == _currentLocale
                                ? appBarColor!
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            languages[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _setLocale(String? value) {
    _flutterLocalization.translate(value!);
    setState(() {
      _currentLocale = value;
    });
    debugPrint(_currentLocale);
  }
}
