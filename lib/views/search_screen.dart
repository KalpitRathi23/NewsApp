import 'package:flutter/material.dart';
import 'package:newshub/models/article_model.dart';
import 'package:newshub/views/news_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<ArticleModel> articles;
  const SearchScreen({super.key, required this.articles});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<ArticleModel> filteredArticles = [];

  @override
  void initState() {
    super.initState();
    filteredArticles = [];
  }

  void filterArticles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredArticles = [];
      } else {
        filteredArticles = widget.articles.where((article) {
          return article.title.toLowerCase().contains(query.toLowerCase()) ||
              article.description.toLowerCase().contains(query.toLowerCase()) ||
              article.author.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search Articles',
            border: InputBorder.none,
          ),
          onChanged: filterArticles,
        ),
      ),
      body: filteredArticles.isEmpty
          ? const Center(
              child: Text(
                'No articles found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                return BlogTile(
                  imageUrl: filteredArticles[index].urlToImage,
                  title: filteredArticles[index].title,
                  desc: filteredArticles[index].description,
                  url: filteredArticles[index].url,
                  date: filteredArticles[index].publishedAt,
                  author: filteredArticles[index].author,
                );
              },
            ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url, date, author;
  const BlogTile({
    required this.imageUrl,
    required this.title,
    required this.desc,
    required this.url,
    required this.date,
    required this.author,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              newsImage: imageUrl,
              newsTitle: title,
              newsDate: date,
              newsDesc: desc,
              newsSource: author,
              newsUrl: url,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
