import 'package:flutter/material.dart';
import 'timeline.dart';
import 'main_screen.dart';

class Likes extends StatefulWidget{
  @override
  LikesState createState() => new LikesState();
}

class LikesState extends State<Likes> {
  var _tweets = timeline_dataSource.generatePosts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
        title: new Text('Liked Posts'),
    ),
      body: ListView(
        // children: <Widget>[
        //   TweetWidget(
        //     tweet: _tweets[0],
        //   ),
        //   TweetWidget(
        //       tweet: _tweets[1]
        //   ),
        // ], //ListView
      ),
    );
  }
}
