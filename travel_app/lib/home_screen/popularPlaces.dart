import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'JapanPreview.dart';
import 'LondonPreview.dart';
import 'BrazilPreview.dart';

class PopularPlaces extends StatelessWidget{
  const PopularPlaces({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlacesTitle(
          title: "Favourite Places",
          press: (){},
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            JapanPreview(press: (){}),
            LondonPreview(press: (){}),
            BrazilPreview(press: (){}),
          ],
        ),
      ],
    );
  }
}

class PlacesTitle extends StatelessWidget {
  const PlacesTitle({
    Key key,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          GestureDetector(
            onTap: press,
            child:
            Text(
              "See All",
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}



