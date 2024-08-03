import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newshub/helper/news.dart';
import 'package:newshub/models/article_model.dart';
import 'package:newshub/views/home.dart';

class CategoryNews extends StatefulWidget {
  final String category;

  const CategoryNews({required this.category, super.key});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "News",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600),
              ),
              Text(
                "Hub",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 2,
        ),
        body: _loading
            ? const Center(
                child: SpinKitCircle(
                  size: 50,
                  color: Colors.blue,
                ),
              )
            : Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return BlogTile(
                        imageUrl: articles[index].urlToImage,
                        title: articles[index].title,
                        desc: articles[index].description,
                        url: articles[index].url,
                        date: articles[index].publishedAt,
                        author: articles[index].author,
                      );
                    }),
              ));
  }
}
