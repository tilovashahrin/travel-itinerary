import 'package:flutter/material.dart';
import 'package:travel_app/models/data_consumption.dart';
import 'package:travel_app/models/graphTitle.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'home_screen/main_screen.dart';

//inspiration on how to label from https://google.github.io/charts/flutter/example/behaviors/chart_title.html
class HomePage extends StatelessWidget {
  static const routeName = '/charts';
  final List<Travel> data = [
    Travel(
      month: 'JAN',
      numbers: 240.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.purpleAccent),
    ),
    Travel(
      month: 'FEB',
      numbers:288.31,
      barColor: charts.ColorUtil.fromDartColor(Colors.indigoAccent),
    ),
    Travel(
      month: 'MAR',
      numbers: 459.39,
      barColor: charts.ColorUtil.fromDartColor(Colors.pink),
    ),
    Travel(
      month: 'APR',
      numbers: 563.82,
      barColor: charts.ColorUtil.fromDartColor(Colors.lightGreenAccent),
    ),
    Travel(
      month: 'MAY',
      numbers: 609.26,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    Travel(
      month: 'JUN',
      numbers: 770.26,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    Travel(
      month: 'JUL',
      numbers: 730.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.cyanAccent),
    ),
    Travel(
      month: 'AUG',
      numbers: 700.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    Travel(
      month: 'SEP',
      numbers: 540.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.teal),
    ),
    Travel(
      month: 'OCT',
      numbers: 500.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    Travel(
      month: 'NOV',
      numbers: 440.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.deepOrange),
    ),
    Travel(
      month: 'DEC',
      numbers: 340.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.pinkAccent),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Travel Times'),
          actions: [
      FlatButton( //Riya added this log out button
      child: Row(
      children: <Widget>[
          Icon(Icons.home,  color: Colors.white),
      ],
    ),

    onPressed: (){
    Navigator.of(context).pushReplacementNamed(MainScreen.routeName); //if pressed route
    },
    ),
    ],
      ),
      body: Center(
        child: DataChart(
          data: data,
        ),
      ),
    );
  }
}