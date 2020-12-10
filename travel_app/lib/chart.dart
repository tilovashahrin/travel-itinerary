import 'package:flutter/material.dart';
import 'package:travel_app/models/data_consumption.dart';
import 'package:travel_app/models/data_cart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'home_screen/main_screen.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/charts';
  final List<Travel> data = [
    Travel(
      month: 'JAN',
      dataInGb: 240.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.purpleAccent),
    ),
    Travel(
      month: 'FEB',
      dataInGb:288.31,
      barColor: charts.ColorUtil.fromDartColor(Colors.indigoAccent),
    ),
    Travel(
      month: 'MAR',
      dataInGb: 459.39,
      barColor: charts.ColorUtil.fromDartColor(Colors.pink),
    ),
    Travel(
      month: 'APR',
      dataInGb: 563.82,
      barColor: charts.ColorUtil.fromDartColor(Colors.lightGreenAccent),
    ),
    Travel(
      month: 'MAY',
      dataInGb: 609.26,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    Travel(
      month: 'JUN',
      dataInGb: 770.26,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    Travel(
      month: 'JUL',
      dataInGb: 730.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.cyanAccent),
    ),
    Travel(
      month: 'AUG',
      dataInGb: 700.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    Travel(
      month: 'SEP',
      dataInGb: 540.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.teal),
    ),
    Travel(
      month: 'OCT',
      dataInGb: 500.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    Travel(
      month: 'NOV',
      dataInGb: 440.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.deepOrange),
    ),
    Travel(
      month: 'DEC',
      dataInGb: 340.45,
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
    Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
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