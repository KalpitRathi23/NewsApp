import 'dart:convert';

import '../models/article_model.dart';
import 'package:http/http.dart' as http;

const String apiKey = 'bf96542d1903409185996974ef854709';

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    var url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=$apiKey');

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["author"] != null &&
            element["title"] != null &&
            element["url"] != null &&
            element["publishedAt"] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            author: element["author"] ?? 'Unknown',
            description: element["description"] ?? '',
            url: element["url"],
            urlToImage: element["urlToImage"] ?? '',
            content: element["content"] ?? '',
            publishedAt: element["publishedAt"],
          );
          news.add(articleModel);
        }
      });
    }
  }
}

class CategoryNewsClass {
  List<ArticleModel> news = [];

  Future<void> getNews(String category) async {
    var url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=$apiKey');

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["author"] != null &&
            element["title"] != null &&
            element["url"] != null &&
            element["publishedAt"] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            author: element["author"] ?? 'Unknown',
            description: element["description"] ?? '',
            url: element["url"],
            urlToImage: element["urlToImage"] ?? '',
            content: element["content"] ?? '',
            publishedAt: element["publishedAt"],
          );
          news.add(articleModel);
        }
      });
    }
  }
}
