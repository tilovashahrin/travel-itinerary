import 'package:flutter/material.dart';

class flightInfoJap extends StatefulWidget{

  @override
  _flightInfoJapState createState() => _flightInfoJapState();
}

class _flightInfoJapState extends State<flightInfoJap>{

  int _sortColumn = 0;
  int _sortRow;
  bool _ascending = true;

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Flights for Osaka, Japan'),
      ),
      body:SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          onSelectAll: (b){},
          sortColumnIndex: _sortColumn,
          sortAscending: _ascending,
          columns: <DataColumn>[
            DataColumn(label: Text('Airline'), numeric: false, onSort: (a, b){}),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Stops')),
            DataColumn(
              label: Text('Price (CAD)'),
              numeric: false,
                onSort: (a, b){
                  setState(() {
                  });
                }
            ),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Image.asset('images/aircanada.png', height: 30.0, width: 30.0),),
              DataCell(Text('2:00 - 15:55')),
              DataCell(Text('1 Stop')),
              DataCell(Text('987')),
            ]),
            DataRow(cells: [
              DataCell(Image.asset('images/aircanada.png', height: 30.0, width: 30.0),),
              DataCell(Text('2:00 - 23:30')),
              DataCell(Text('2 Stops')),
              DataCell(Text('797')),
            ]),
            DataRow(cells: [
              DataCell(Image.asset('images/japanairlines.png', height: 30.0, width: 30.0)),
              DataCell(Text('9:07 - 20:25')),
              DataCell(Text('1 Stop')),
              DataCell(Text('1203')),
            ]),
            DataRow(cells: [
              DataCell(Image.asset('images/japanairlines.png', height: 30.0, width: 30.0)),
              DataCell(Text('6:07 - 18:00')),
              DataCell(Text('No Stops')),
              DataCell(Text('1590')),
            ]),
            DataRow(cells: [
              DataCell(Image.asset('images/japanairlines.png', height: 30.0, width: 30.0)),
              DataCell(Text('3:45 - 15:00')),
              DataCell(Text('No Stops')),
              DataCell(Text('1203')),
            ]),
            DataRow(cells: [
              DataCell(Image.asset('images/westjet.png', height: 30.0, width: 30.0)),
              DataCell(Text('6:15 - 19:00')),
              DataCell(Text('1 Stop')),
              DataCell(Text('1007')),
            ]),
          ],
        ),
      ),
    );
  }
}