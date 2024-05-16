

class Article {
  final String category;
  final String date;
  final String title;
  final String link;
  final String author;
  final String contentShort;
  final String thumbnailLink;
  final String contentLong;

  Article({
    required this.category,
    required this.date,
    required this.title,
    required this.link,
    required this.author,
    required this.contentShort,
    required this.thumbnailLink,
    required this.contentLong,
  });


  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      category: json['category'],
      date: json['date'],
      title: json['title'],
      link: json['link'],
      author: json['author'],
      contentShort: json['content_short'],
      thumbnailLink: json['thumbnail_link'],
      contentLong: json['content_long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'date': date,
      'title': title,
      'link': link,
      'author': author,
      'content_short': contentShort,
      'thumbnail_link': thumbnailLink,
      'content_long': contentLong,
    };
  }
}
