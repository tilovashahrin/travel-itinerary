import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'trip_components/day.dart';
import 'trip_components/event.dart';
import 'maps/select_location.dart';
import 'package:latlong/latlong.dart';

// Page to modify a previously created event

class EditEvent extends StatefulWidget {
  EditEvent({Key key, this.title, this.event, this.day}) : super(key: key);
  final Event event;
  final Day day;
  final String title;

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  TextEditingController _nameController, _descriptionController;
  String _name, _location, _description;
  TimeOfDay _startTime, _endTime;
  Event _updatedEvent;
  LatLng locCoords;

  @override

  void initState() {
    super.initState();
    _updatedEvent = widget.event;
    _name = _updatedEvent.name;
    _location = _updatedEvent.location;  
    _description = _updatedEvent.description;
    _startTime = _updatedEvent.startTime;
    _endTime = _updatedEvent.endTime;
    _nameController = new TextEditingController(text: _name);
    _descriptionController = new TextEditingController(text: _description);
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Event",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
          //return to view_event page with no event
          onPressed: () => Navigator.pop(context, null)
        ),
        actions: <Widget> [

        //delete event button
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black,),
            onPressed: () {
            //show dialogue asking user to confirm deletion
              showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Event?'),
                        //content: Text('Permanently delete event?'),
                        actions: <Widget>[
                        //confirm delete
                          FlatButton(
                            child: Text('Delete'),
                            onPressed: () {
                              //mark event for deletion
                              _updatedEvent.markForDeletion();
                              //return event to view event page
                              Navigator.pop(context, null);
                              Navigator.pop(context, _updatedEvent);
                            },
                          ),
                        //cancel delete
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context, null);
                            },
                          )
                        ],
                      );
                    },
                  );
              }
            ),
          ]
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
                    controller: _nameController,
                    //store text when textfield is edited
                    onChanged: (text) {
                      _name = text;
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
                    _location,
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
                child: TextField(
                  controller: _descriptionController,
                  onChanged: (text) {
                  _description = text;
                }),
              ),

          //Time Selection
            //Start Time
            Container(
                child: Text(
                  "Start Time:    " + _startTime.format(context),
                  style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            //End Date
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                    "End Time:    " + _endTime.format(context),
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
            if (_name != null && _location != null &&  _description!= null
              && _startTime != null && _endTime != null)  {
            //update event
              _updatedEvent.name = _name;
              _updatedEvent.location = _location;
              _updatedEvent.description = _description;
              _updatedEvent.startTime = _startTime;
              _updatedEvent.endTime = _endTime;
            //check if time conflicts with pre-existing events
              if (widget.day.timeSlotAvailable(_updatedEvent)) {
                //no conflict, return event to event list
                Navigator.of(context).pop(_updatedEvent);
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
          child: Icon(Icons.save, color: Colors.black,),
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
      //labels:
    );
    setState(() {
      _startTime = range.startTime;
      _endTime = range.endTime;
    });
  }

  Future<void> getLocation() async {
    //get location from select_location page
    var loc = await Navigator.push(context, MaterialPageRoute(builder: (context) {return SelectLocation();}));
    if (loc != null){
      setState(() {
        _location = loc[0];
        locCoords = loc[1];
      });
    }
  }

}