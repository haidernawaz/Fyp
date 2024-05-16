import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:http/http.dart' as http;
import 'package:legalassistance/Constants/constants.dart';
import 'package:legalassistance/CustomWidgets/app_bar.dart';
import 'package:legalassistance/Locales/locales.dart';
import 'package:legalassistance/Screens/NewsReading/web_view_page.dart';

// import 'package:shimmer/shimmer.dart';
import 'news_model.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({super.key});

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  List<Article> articles = [];
  bool isLoading = false;
  int currentPage = 1;
  bool isFetching = false;
  int totalArticles = 0;
  final ScrollController _scrollController = ScrollController();
  static const backGroundColor = Color(0xFF121212);
  static const textGreyColor2 = Color(0xFFBDBDBD);

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(Uri.parse(
          'http://192.168.18.66:8000/get_news?num_pages=5&page=$currentPage&per_page=10#'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonArticles =
            jsonDecode(response.body)['articles'];
        final List<Article> fetchedArticles =
            jsonArticles.map((json) => Article.fromJson(json)).toList();
        setState(() {
          totalArticles = jsonDecode(response.body)['total_count'];
          articles = fetchedArticles;
          isLoading = false;
        });
      }
    } catch (e) {
      log("Error in fetching news: ${e.toString()}");
    }
  }

  Future<void> fetchNextPage() async {
    setState(() {
      isFetching = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.18.66:8000//get_news?num_pages=5&page=${currentPage + 1}&per_page=10'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonArticles =
            jsonDecode(response.body)['articles'];
        final List<Article> nextPageArticles =
            jsonArticles.map((json) => Article.fromJson(json)).toList();
        setState(() {
          articles.addAll(nextPageArticles);
          currentPage++;
          isFetching = false;
        });
      }
    } catch (e) {
      log("Error in fetching news: ${e.toString()}");
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isFetching) {
          fetchNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: showAppBar(context, 'Latest News'),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
            ))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: articles.length + (isFetching ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < articles.length) {
                        final article = articles[index];
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          color: appBarColor!.withOpacity(0.3),
                          child: Column(
                            children: [
                              article.thumbnailLink == 'N/A'
                                  ? const SizedBox.shrink()
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                      child: Image.network(
                                        article.thumbnailLink,
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.height,
                                        loadingBuilder:
                                            (context, widget, chunk) {
                                          if (chunk == null) {
                                            return widget;
                                          } else {
                                            return Center(
                                              child: Text('Loading News'),
                                            );
                                            // return Shimmer.fromColors(
                                            //   baseColor: Colors.black,
                                            //   highlightColor:
                                            //       Colors.black.withOpacity(0.7),
                                            //   child: Container(
                                            //     color: Colors.grey,
                                            //     height: 200,
                                            //     width: MediaQuery.of(context)
                                            //         .size
                                            //         .height,
                                            //   ),
                                            // );
                                          }
                                        },
                                      )),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WebViewPage(url: article.link),
                                    ),
                                  );
                                },
                                title: Text(
                                  article.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      article.contentShort,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      article.author,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                    Text(
                                      article.date,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (totalArticles == articles.length &&
                          totalArticles != 0) {
                        // Display message when all articles have been loaded
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'No more articles',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CupertinoActivityIndicator(
                            radius: 20,
                            color: textGreyColor2,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
