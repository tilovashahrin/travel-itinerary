import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'trip.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key key, this.title, this.day}) : super(key: key);
  final Day day;
  final String title;

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String name, location, description;
  TimeOfDay startTime, endTime;
  String startTimeString = "No Time Chosen";
  String endTimeString = "No Time Chosen";

  //temporary UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Add Event"),
      
      ),
      body:
        SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.all(15),
          child:
            Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
            //Name of Event
              Container(
                child:
                  Text("Event Name: ", textScaleFactor: 1, textAlign: TextAlign.left),
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
            //Location
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
                  child: Text("Start Time: ",
                    textScaleFactor: 1, textAlign: TextAlign.left),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //display current selected date
                  Text(startTimeString, textScaleFactor: 1, textAlign: TextAlign.left),
                  RaisedButton(
                      child: Text('Select'),
                      onPressed: () {
                        _getTimes();
                      })
                ],
              ),
            //End Time
            Container(
                  child: Text("End Time: " + endTimeString,
                    textScaleFactor: 1, textAlign: TextAlign.left),
              ),
            ]),
      ),
        ),
      //Save button
        floatingActionButton:Builder(
        builder: (context) =>  FloatingActionButton(
          onPressed: () {
          //if all fields have been changed and times have been selected
            if (name != null && location != null &&  description!= null
              && startTime != null && endTime != null) {
            //create Event instance
              Event entry = Event(
                  name: name,
                  location: location,
                  description: description,
                  startTime: startTime,
                  endTime: endTime
              );
            //check if time conflicts with pre-existing events
              if (widget.day.timeSlotAvailable(entry)) {
                //no conflict, return event to event list
                Navigator.of(context).pop(entry);
              }
              else {
            //conflict, show dialog telling user to pick a new time
                 showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Time Conflict'),
                      content: Text(
                          'The timing of this event conflicts with another event this day.'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Change Time'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
            else {
          //show snackbar if some fields incomplete
            var snackbar = SnackBar(content: Text('Fill out all fields.'));
            Scaffold.of(context).showSnackBar(snackbar);
            }         
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blue,
        )
      )
    );
  }

  //function to call time range picker and get times from user
  Future<void> _getTimes() async {
    TimeRange range = await showTimeRangePicker(
      context: context,
      use24HourFormat: false,
      interval: Duration(minutes: 1),
      start: TimeOfDay(hour: 0, minute: 0),
      //labels:
    );
    startTime = range.startTime;
    endTime = range.endTime;
    setState(() {
      startTimeString= startTime.format(context);
      endTimeString= endTime.format(context);
    });

  }

}