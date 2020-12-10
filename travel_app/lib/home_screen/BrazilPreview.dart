import 'package:flutter/material.dart';
import 'package:travel_app/DataTables/BrazilFlight.dart';

class BrazilPreview extends StatelessWidget {
  const BrazilPreview({
    Key key,
    @required this.press,
  }) : super(key: key);

  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 150.0,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.19,
            child: Container(
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage("images/brazil.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BrazilFlightData()));
            },
            child: Container(
              width: 100.0,
              height: 60.0,
              padding: EdgeInsets.all(15.0),
              decoration:
              BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Rio, Brazil",
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}