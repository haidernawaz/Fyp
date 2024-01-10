// NewsDetailScreen.dart

import 'package:flutter/material.dart';
import 'package:legalassistance/Constants/constants.dart';

import '../HomeScreen/home_screen.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor,
        title: Text(
          'News Detail',
          style: appBarStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.urlToImage != null)
                  Image.network(article.urlToImage!),
                SizedBox(height: 16.0),
                Text(
                  article.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                if (article.sourceName != null)
                  Text('Source: ${article.sourceName}'),
                if (article.author != null) Text('Author: ${article.author}'),
                Text('Published At: ${article.publishedAt}'),
                Text('Description: ${article.description}'),
                Text('Content: ${article.content}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
