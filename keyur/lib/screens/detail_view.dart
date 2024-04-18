// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebView extends StatefulWidget {
//   // final String newImage,newsTitle, newsDate,author,description,content,source;
//   const WebView({super.key});

//   @override
//   State<WebView> createState() => _WebViewState();
// }

// class _WebViewState extends State<WebView> {

//   final controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..loadRequest(Uri.parse("https://youtube.com"));

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: WebViewWidget(controller: controller,));
//   }
// }

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:test_2/repository/web_view_news_repository.dart';


class WebView extends StatefulWidget {
  final String newsTitle;
  final String newsDate;
  final String author;
  final String description;
  final String content;
  final String source;

  const WebView({
    super.key,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  });

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_buildNewsUrl()));
  }

  String _buildNewsUrl() {
    // Construct the news URL based on the provided parameters
    // For example, you could use a template like:
    // "https://example.com/news?title=${widget.newsTitle}&date=${widget.newsDate}&author=${widget.author}&description=${widget.description}&content=${widget.content}&source=${widget.source}"
    return 'https://newsapi.org/v2/top-headlines/sources?apiKey=3935233245964f748dd3ec4594b5471c';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebViewWidget(controller: _controller),
    );
  }
}