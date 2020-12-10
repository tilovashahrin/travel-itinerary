import 'data_consumption.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//data graph
class DataChart extends StatelessWidget {
  final List<Travel> data;
  const DataChart({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<charts.Series<Travel, String>> series = [
      charts.Series(
        data: data,
        id: "Travel",
        domainFn: (Travel series, _) => series.month,
        measureFn: (Travel series, _) => series.numbers,
        colorFn: (Travel series, _) => series.barColor,
      )
    ];
    return Container(
      //height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Column(
          children: <Widget>[
            Text(
              "Best Time to Travel Monthly \n          Based on Votes \n",style: TextStyle(fontSize: 26.0,color: Colors.cyan[900],fontWeight: FontWeight.bold,fontStyle:FontStyle.italic),
              //style: Theme.of(context).textTheme.bodyText2,
            ),
            Expanded(
              child: charts.BarChart(
                series,
                animate: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
