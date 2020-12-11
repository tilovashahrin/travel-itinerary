//search bar non functional
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget{
  //const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: -2,
            blurRadius: 7,
            offset: Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        decoration:
        InputDecoration(
          hintText:"Eg.: Toronto, Canada",
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.black38,
          ),
          prefixIcon: Icon(
            Icons.location_on,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            //onPressed: ,
          ),
          contentPadding:
          EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
        ),
      ),
    );
  }
}