import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'trip_components/day.dart';
import 'trip_components/event.dart';
import 'maps/select_location.dart';
import 'package:latlong/latlong.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key key, this.title, this.day}) : super(key: key);
  final Day day;
  final String title;

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String name, description;
  TimeOfDay startTime, endTime;
  String startTimeString = "No Time Chosen";
  String endTimeString = "No Time Chosen";
  String location = "No Location Selected";
  LatLng locCoords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Add Event",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        leading: BackButton(
          color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            })
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
                child: Text(
                    "Event Name ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
                child: Text(
                  "Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    location,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  RaisedButton(
                    child: Text('Select'),
                    color: Colors.white,
                    onPressed: () {
                      getLocation();
                    }
                  )
                ],
              ),

              //Description
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text("Description",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                width: 0.8 * MediaQuery.of(context).size.width,
                child: TextField(onChanged: (text) {
                  description = text;
                }),
              ),

          //Time Selection
            //Start Time
            Container(
                child: Text(
                  "Start Time:    " + startTimeString,
                  style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            //End Date
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                    "End Time:    " + endTimeString,
                    style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

            //Select Dates button
              RaisedButton(
                  color: Colors.white,
                  child: Text('Select Times'),
                  onPressed: () {
                    _getTimes();
                  })
            ]),
      ),
        ),
      //Save button
        floatingActionButton:Builder(
        builder: (context) =>  FloatingActionButton(
          onPressed: () {
          //if all fields have been changed and times have been selected
            if (name != null && description!= null
              && startTime != null && endTime != null && locCoords != null) {
            //create Event instance
              Event entry = Event(
                  name: name,
                  location: location,
                  description: description,
                  startTime: startTime,
                  endTime: endTime,
                  lat: locCoords.latitude,
                  lng: locCoords.longitude
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
          child: Icon(Icons.save, color: Colors.black),
                  backgroundColor: Colors.white,
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
    );
    startTime = range.startTime;
    endTime = range.endTime;
    setState(() {
      startTimeString= startTime.format(context);
      endTimeString= endTime.format(context);
    });
  }

  Future<void> getLocation() async {
    //get location from location selection page
    var loc = await Navigator.push(context, MaterialPageRoute(builder: (context) {return SelectLocation();}));
    if (loc != null){
      setState(() {
        //if location returned set event's location
        location = loc[0];
        locCoords = loc[1];
      });
    }
  }

}