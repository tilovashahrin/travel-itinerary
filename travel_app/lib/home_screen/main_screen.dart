import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'timeline.dart';
import '../like_screen.dart';
import '../trip_manager/view_trip_list.dart';
import 'package:travel_app/home_screen/appbar_body.dart';

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
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
          onPressed: (){},
        ),
        actions: [
          IconButton(
            icon:
            ClipOval(
              child: Image.asset("images/profile.png"),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body:
      ListView(
        children: <Widget>[
          App_Body(),
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
                    builder: (context) => Likes(),
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
                    builder: (context) => ViewTripList(),
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