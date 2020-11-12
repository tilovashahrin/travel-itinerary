import 'package:flutter/material.dart';
import 'trip.dart';
import 'utils.dart';

class AddTrip extends StatefulWidget {
  AddTrip({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  String name, location, description;
  DateTime startDate, endDate;
  String startDateString = "No Date Chosen";
  String endDateString = "No Date Chosen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(widget.title),
      ),
      body:
        SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.all(15),
          child:
            Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
            //Name of Trip
              Container(
                child:
                  Text("Trip Name: ", textScaleFactor: 1, textAlign: TextAlign.left),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  width: 0.8 * MediaQuery.of(context).size.width,
                  child: TextField(
                    //store text when textfield is edited
                    onChanged: (text) {
                      name = text;
                    }
                  ),
                ),
            //Species Section
              Container(
                child:
                  Text("Location: ", textScaleFactor: 1, textAlign: TextAlign.left),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  width: 0.8 * MediaQuery.of(context).size.width,
                  child: TextField(
                    onChanged: (text) {
                      location = text;
                    }
                  ),
                ),
            //Description
              Container(
                child:
                  Text("Description: ", textScaleFactor: 1, textAlign: TextAlign.left),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  width: 0.8 * MediaQuery.of(context).size.width,
                  child: TextField(
                    onChanged: (text) {
                      description = text;
                    }
                  ),
                ),

            //Date Selection
            //Start Date
            Container(
                  child: Text("Start Date: ",
                    textScaleFactor: 1, textAlign: TextAlign.left),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //display current selected date
                  Text(startDateString, textScaleFactor: 1, textAlign: TextAlign.left),
                  RaisedButton(
                      child: Text('Select'),
                      onPressed: () {
                        _getStartDate();
                      })
                ],
              ),
            //End Date
            Container(
                  child: Text("End Date: ",
                    textScaleFactor: 1, textAlign: TextAlign.left),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //display current selected date
                  Text(endDateString, textScaleFactor: 1, textAlign: TextAlign.left),
                  RaisedButton(
                      child: Text('Select'),
                      onPressed: () {
                        _getEndDate();
                      })
                ],
              ),

            ]),
      ),
        ),
      //Save button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //if all fields have been changed and dates have been selected
            if (name != null && location != null &&  description!= null
              && startDate != null && endDate != null) {
              //create Trip instance
              Trip entry = Trip(
                  name: name,
                  location: location,
                  description: description,
                  startDate: startDate,
                  endDate: endDate);
              entry.initDays();
              Navigator.of(context).pop(entry); //return new trip
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.teal,
        )
      );
  }

  //functions to call date picker and get dates from user
  //add verification that dates don't overlap
  Future<void> _getStartDate() async {
    //get start date of trip
    await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      initialDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        startDate = value;
        setState(() {
          startDateString= toDateString(startDate) + " ${startDate.year}";
        });
      }
    });
  }

  Future<void> _getEndDate() async {
    await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      initialDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        endDate = value;
        setState(() {
          endDateString= toDateString(endDate) + " ${endDate.year}";
        });
      }
    });
  }

}