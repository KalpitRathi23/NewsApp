// ignore_for_file: non_constant_identifier_names, deprecated_member_use, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsImage;
  final String newsTitle;
  final String newsDate;
  final String newsDesc;
  final String newsSource;
  final String newsUrl;
  const NewsDetailScreen({
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.newsDesc,
    required this.newsSource,
    required this.newsUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MMMM dd,yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double Kwidth = MediaQuery.of(context).size.width;
    double Kheight = MediaQuery.of(context).size.height;
    DateTime dateTime = DateTime.parse(widget.newsDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'News',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'Hub',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black),
            onPressed: _showModalBottomSheet,
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            // padding: EdgeInsets.symmetric(horizontal: Kheight * 0.02),
            height: Kheight * 0.4,
            width: Kwidth,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: widget.newsImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.newsImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Image.asset(
                          'assets/empty_image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Center(
                      child: Image.asset(
                        'assets/empty_image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Kheight * 0.4),
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            height: Kheight * 0.6,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: ListView(
              children: [
                Text(widget.newsTitle,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: Kheight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.newsSource,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: Kheight * 0.03,
                ),
                Text(
                    widget.newsDesc.isNotEmpty
                        ? widget.newsDesc
                        : 'No description found',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  height: Kheight * 0.03,
                ),
                // GestureDetector(
                //   onTap: () async {
                //     final Uri url = Uri.parse(widget.newsUrl);
                //     if (!await launchUrl(url)) {
                //       throw Exception('Could not launch $url');
                //     }
                //   },
                //   child: RichText(
                //     text: TextSpan(
                //       style: GoogleFonts.poppins(
                //         fontSize: 15,
                //         color: Colors.black,
                //         fontWeight: FontWeight.w500,
                //       ),
                //       children: [
                //         const TextSpan(
                //           text: "For more information visit - ",
                //           style: TextStyle(
                //             decoration: TextDecoration.none,
                //           ),
                //         ),
                //         TextSpan(
                //           text: widget.newsUrl,
                //           style: const TextStyle(
                //             color: Colors.blue,
                //             decoration: TextDecoration.underline,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text('Open in browser'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _launchUrl(widget.newsUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () async {
                  try {
                    Navigator.of(context).pop();
                    await Share.share("Link to the news - ${widget.newsUrl}",
                        subject: 'Look at this news!');
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to share the content.'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
