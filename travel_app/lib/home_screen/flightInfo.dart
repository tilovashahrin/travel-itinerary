import 'package:flutter/material.dart';

class flightInfo extends StatefulWidget{

  @override
  _flightInfoState createState() => _flightInfoState();
}

class _flightInfoState extends State<flightInfo>{

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Flights'),
      ),
      body:SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:
        DataTable(
          sortColumnIndex: 0,
          sortAscending: true,
          columns: [
            DataColumn(label: Text('Airline')),
            DataColumn(label: Text('Datre')),
            DataColumn(label: Text('Stops')),
            DataColumn(
              label: Text('Price (CAD)'),
              numeric: true,
            ),
          ],
          rows: [
            DataRow(cells: [
              DataCell(
                  Text(
                    'Air Canada',

                  ),
              ),
              DataCell(Text('2:00 - 15:55')),
              DataCell(Text('2 Stops')),
              DataCell(Text('987')),
            ]),
            DataRow(cells: [
              DataCell(Text('Japan Airlines')),
              DataCell(Text('9:07 - 18:25')),
              DataCell(Text('No Stops')),
              DataCell(Text('1203')),
            ]),
            DataRow(cells: [
              DataCell(Text('WestJet')),
              DataCell(Text('6:15 - 19:00')),
              DataCell(Text('1 Stops')),
              DataCell(Text('1007')),
            ]),
          ],
        ),
      ),
    );
  }
}