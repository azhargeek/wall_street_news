import 'dart:async';
import 'dart:convert';
import 'package:news_demo_livestream/models/newsInfo.dart';
import 'package:http/http.dart' as http;
import 'package:news_demo_livestream/constants/strings.dart';

enum NewsAction { Fetch, Delete }

class NewsBlock{
    final _stateStreamController =  StreamController<List<Article>>();
    StreamSink<List<Article>>  get _newsSink =>  _stateStreamController.sink;
    Stream<List<Article>>  get newsStream => _stateStreamController.stream;


    final _eventStreamController = StreamController<NewsAction>();
    StreamSink<NewsAction>  get eventSink =>  _eventStreamController.sink;
    Stream<NewsAction>  get _eventStream => _eventStreamController.stream;

    Future<NewsModel> fetchNewsArticles() async {
      var client = http.Client();
      var newsModel;
      try {
        var response = await client.get(Strings.news_url);

        if (response.statusCode == 200) {
          var jsonString = response.body;
          var jsonMap = jsonDecode(jsonString);
          newsModel = NewsModel.fromJson(jsonMap);
        }
      } catch (Exception) {
        return newsModel;
      }
      return newsModel;
  }


     NewsBlock(){
       _eventStream.listen((event)  async {
         if(event == NewsAction.Fetch){
           try {
             var  news = await fetchNewsArticles();
             if(news != null) 
              _newsSink.add(news.articles);
           } on Exception catch (e) {
             _newsSink.addError(e.toString());
           }
         }
       });

     }

    void dispose(){
      _stateStreamController.close();
      _eventStreamController.close();
    }

}