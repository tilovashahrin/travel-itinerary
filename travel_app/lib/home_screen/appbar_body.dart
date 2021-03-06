import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'searchBar.dart';

//top picture of main page with title
class App_Body extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              "images/background.png",
              height: 325,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //SizedBox(height: 80),
                Text(
                  "Travel Log",
                  style: TextStyle(
                    fontSize: 60,
                    //fontStyle: ,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 2,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 25,
              child:
              SearchBar(),
            ),
          ],
        ),
      ],
    );
  }
}

