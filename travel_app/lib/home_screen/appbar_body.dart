import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App_Body extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              "images/background.png",
              height: 315,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
          ],
        ),
      ],
    );
  }
}