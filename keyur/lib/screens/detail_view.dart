import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final String newsTitle;
  final String newsDate;
  final String author;
  final String description;
  final String content;
  final String source;

  const WebView({
    Key? key,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  }) : super(key: key);

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
    return 'https://newsapi.org/v2/top-headlines/sources?apiKey=2746d82c5ebb402d95ef4232e5a46f40';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('News Article'),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
