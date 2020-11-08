import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: ListView(
        // children: <Widget>[
        // ], //ListView
        // ),
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    //builder: (context) => _EventScreen(),
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