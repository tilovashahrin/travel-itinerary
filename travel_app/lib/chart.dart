import 'package:flutter/material.dart';
import 'package:travel_app/models/data_consumption.dart';
import 'package:travel_app/models/data_cart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'home_screen/main_screen.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/charts';
  final List<DataConsumption> data = [
    DataConsumption(
      month: 'JAN',
      dataInGb: 540.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DataConsumption(
      month: 'FEB',
      dataInGb:188.31,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DataConsumption(
      month: 'MAR',
      dataInGb: 159.39,
      barColor: charts.ColorUtil.fromDartColor(Colors.pink),
    ),
    DataConsumption(
      month: 'APR',
      dataInGb: 163.82,
      barColor: charts.ColorUtil.fromDartColor(Colors.deepPurple),
    ),
    DataConsumption(
      month: 'MAY',
      dataInGb: 209.26,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DataConsumption(
      month: 'JUN',
      dataInGb: 170.26,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    DataConsumption(
      month: 'JUL',
      dataInGb: 130.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DataConsumption(
      month: 'AUG',
      dataInGb: 540.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DataConsumption(
      month: 'SEP',
      dataInGb: 540.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DataConsumption(
      month: 'OCT',
      dataInGb: 540.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DataConsumption(
      month: 'NOV',
      dataInGb: 540.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DataConsumption(
      month: 'DEC',
      dataInGb: 540.45,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Data Consumption'),
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