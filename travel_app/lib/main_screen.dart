//tilova  (Riya incorp login to homepage)
import 'package:flutter/material.dart';
import 'timeline.dart';
import 'trip_manager/list_trips.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _tweets = timeline_dataSource.generatePosts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),//Riya added this to call home when log in is clicked
      ),
      body: ListView(
        children: <Widget>[
          TweetWidget(
            tweet: _tweets[0],
          ),
          TweetWidget(
              tweet: _tweets[1]
          ),
        ], //ListView
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 10.0,
                height: 10.0),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                );
              },
              icon: Icon(Icons.home, size: 40),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //builder: (context) => _likeScreen(),
                  ),
                );
              },
              icon: Icon(Icons.favorite, size: 40),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //builder: (context) => _EventScreen(),
                  ),
                );
              },
              icon: Icon(Icons.add, size: 40),
            ),
            IconButton(
            //view user's trips  
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripList(),
                  ),
                );
              },
              icon: Icon(Icons.person, size: 40),
            ),
            SizedBox(
              height: 10.0,
              width: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}