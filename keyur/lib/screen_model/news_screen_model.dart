
import 'package:test_2/models/News_Channel_Headlines_Model.dart';
import 'package:test_2/repository/news_repository.dart';
import 'package:test_2/models/categories_news_model.dart';

class NewsScreenModel {
  final _rep = NewsRepository();

  // Future<NewsChannelHeadlinesModel> fetchNewsChannelheadlinesApi(List<String> newsChannels) async {
  //   final response = await _rep.fetchNewsChannelheadlinesApi(newsChannels);
  //   return response;
  // }

  // List<String> newsChannels = ['bbc-news', 'ary-news', 'google-news-in'];
  
  Future<NewsChannelHeadlinesModel> fetchNewsChannelheadlinesApi(String channelName) async{
    final response = await _rep.fetchNewsChannelheadlinesApi(channelName);
    return response ;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response ;
  }

 


}
