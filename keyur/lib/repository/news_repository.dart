
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:test_2/models/News_Channel_Headlines_Model.dart';
import 'package:test_2/models/categories_news_model.dart';

class NewsRepository{

  Future<NewsChannelHeadlinesModel> fetchNewsChannelheadlinesApi(String channelName) async{

    String url = 'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=c0d5461ec7014be3a8e40a2f2eff66c1';

    print(url);
    final response = await http.get(Uri.parse(url));

    if(kDebugMode){

       print(response.body);
    }
   
    if(response.statusCode == 200){

      final body =jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }



  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{

    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=c0d5461ec7014be3a8e40a2f2eff66c1';

    print(url);
    final response = await http.get(Uri.parse(url));

    if(kDebugMode){

       print(response.body);
    }
   
    if(response.statusCode == 200){

      final body =jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}