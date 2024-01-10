import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:legalassistance/Packages/packages.dart';

import '../BookReading/book_reading.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.guestEntry});
  bool guestEntry;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  List books = [
    'assets/books/admlaw.pdf',
    'assets/books/bermanlaw.pdf',
    'assets/books/blackletter.pdf',
    'assets/books/generallaw.pdf',
    'assets/books/law.pdf',
    'assets/books/ssrn.pdf'
  ];
  List coverPages = [
    'assets/coverpages/admlaw.png',
    'assets/coverpages/blackletter.png',
    'assets/coverpages/genlaw.png',
    'assets/coverpages/law243.png',
    'assets/coverpages/lawandreligion.png',
    'assets/coverpages/ssrn.png'
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchUserData();
  }

  String userFirstName = '';
  String userLastName = '';
  String userRole = '';
  String userNumber = '';

  fetchUserData() async {
    var currentUser = FirebaseAuth.instance.currentUser!;
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();
    setState(() {
      userFirstName = userSnapshot['firstname'];
      userLastName = userSnapshot['lastname'];
      userRole = userSnapshot['role'];
      userNumber = userSnapshot['phoneNumber'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return WillPopScope(
      onWillPop: () async {
        if (widget.guestEntry) {
          Navigator.of(context).pop();
          return true;
        } else {
          bool exit1 = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return showExitPopup(context);
            },
          );

          if (exit1 == true) {
            exit(0);
          }

          return false;
        }
      },
      child: Scaffold(
        backgroundColor: scaffoldColor, // Set your desired background color
        appBar: showAppBar(context, LocalesData.appbar.getString(context)),
        drawer: widget.guestEntry
            ? null
            : showDrawer(context, userRole == 'lawyer' ? true : false),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: homeButton(() {
                    screenFunction.nextScreen(
                        context,
                        AskQueryScreen(
                          guestEntry: widget.guestEntry,
                          lawyer: userRole == 'lawyer' ? true : false,
                        ));
                  }, LocalesData.homeAsk.getString(context), height, width),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    LocalesData.books.getString(context),
                    style: lawyerNameStyle,
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: coverPages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            screenFunction.nextScreen(
                                context,
                                PdfReadScreen(
                                  pdfPath: books[index],
                                ));
                          },
                          child: Container(
                              height: height * 0.1,
                              color: Colors.yellow,
                              child: Image.asset(
                                coverPages[index],
                                fit: BoxFit.fill,
                              )),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    LocalesData.todayNews.getString(context),
                    style: lawyerNameStyle,
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            screenFunction.nextScreen(
                              context,
                              NewsDetailScreen(
                                article: articles[index],
                              ),
                            );
                          },
                          child: Container(
                            height: height * 0.3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: articles[index].urlToImage != null
                                        ? NetworkImage(
                                            articles[index].urlToImage!)
                                        : NetworkImage(''),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffC2C2C2)),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                articles[index].title,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                // Your body content goes here
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=9606e606d78e4c098d8608e606a1249f'),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'ok') {
        List<dynamic> articlesData = data['articles'];

        setState(() {
          articles =
              articlesData.map((article) => Article.fromJson(article)).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Article {
  final String? sourceName;
  final String? author;
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String content;

  Article({
    this.sourceName,
    this.author,
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      sourceName: json['source']['name'],
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}
