import 'package:flutter/material.dart';
import 'package:news_demo_livestream/models/newsInfo.dart';
import 'package:news_demo_livestream/news_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newsBloc = NewsBlock();

  @override
  void initState() {
    newsBloc.eventSink.add(NewsAction.Fetch);
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();

    newsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Container(
        child: StreamBuilder<List<Article>>(
          stream : newsBloc.newsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data[index];
                    var formattedTime = DateFormat('dd MMM - HH:mm')
                        .format(article.publishedAt);
                    return Container(
                      height: 100,
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.network(
                                  article.urlToImage,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(formattedTime),
                                Text(
                                  article.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  article.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
