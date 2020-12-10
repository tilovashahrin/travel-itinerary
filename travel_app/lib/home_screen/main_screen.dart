import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:travel_app/trip_manager/add_trip.dart';
import '../login_screen.dart';
import 'timeline.dart';
import '../like_screen.dart';
import '../trip_manager/view_trip_list.dart';
import 'appbar_body.dart'; //had to change this to run -riya
import 'popularPlaces.dart';
import 'package:travel_app/login_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/home'; //need for routing -riya
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _tweets = timeline_dataSource.generatePosts();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBodyBehindAppBar: true,
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Randy Fortier"),
              accountEmail: new Text('randy.fortier@gmail.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage('images/profile.png'),
              ),
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
          icon: new Icon(Icons.menu),
          color: Colors.black,
            onPressed: ()=> Scaffold.of(context).openDrawer(

            ),
          ),
        ),
        actions: [
          // IconButton(
          //   icon:
          //   ClipOval(
          //     child: Image.asset("images/profile.png"),
          //   ),
          //   onPressed: () {},
          // ),
          FlatButton( //Riya added this log out button
            child: Row(
              children: <Widget>[
                Text('Logout'),
                Icon(Icons.person_add)
              ],
            ),
            textColor: Colors.black,

            onPressed: (){
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          )
        ],
      ),

      body:
      ListView(
        children: <Widget>[
          App_Body(),
          PopularPlaces(),
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
                    builder: (context) => AddTrip(),
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