// news_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchNewsArticle(String source, String apiKey) async {
  final url = Uri.parse('https://newsapi.org/v2/top-headlines?sources&apiKey=c0d5461ec7014be3a8e40a2f2eff66c1');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final article = data['articles'][0];
    return {
      'newsTitle': article['title'],
      'newsDate': article['publishedAt'],
      'author': article['author'],
      'description': article['description'],
      'content': article['content'],
      'source': article['source']['name'],
    };
  } else {
    throw Exception('Failed to fetch news article');
  }
}