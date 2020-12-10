import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'trip_components/day.dart';
import 'trip_components/event.dart';

class EditEvent extends StatefulWidget {
  EditEvent({Key key, this.title, this.event, this.day}) : super(key: key);
  final Event event;
  final Day day;
  final String title;

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  TextEditingController _nameController, _locationController, _descriptionController;
  String _name, _location, _description;
  TimeOfDay _startTime, _endTime;
  Event _updatedEvent;

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
    _locationController = new TextEditingController(text: _location);
    _descriptionController = new TextEditingController(text: _description);
  }

  Widget build(BuildContext context) {
    // final Event _ogEvent = widget.event;
    // print(_ogEvent.startTime.format(context));
    // print(_ogEvent.endTime.format(context));
    // print(_ogEvent.location);
    // print(_ogEvent.name);
    // print(_ogEvent.description);


    return Scaffold(
      appBar: AppBar(
      title: Text("Edit Event"),
      leading: BackButton(onPressed: () => Navigator.pop(context, null)),
      actions: <Widget> [
      //delete event button
        IconButton(
          icon: Icon(Icons.delete),
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
                            _updatedEvent.markForDeletion();
                            //return null to view event page
                            Navigator.pop(context, null);
                            Navigator.pop(context, _updatedEvent);
                          },
                        ),
                      //cancel delete
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {},
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
                child:
                  Text("Event Name: ", textScaleFactor: 1, textAlign: TextAlign.left),
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
                child:
                  Text("Location: ", textScaleFactor: 1, textAlign: TextAlign.left),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  width: 0.8 * MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: _locationController,
                    onChanged: (text) {
                      _location = text;
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
                    controller: _descriptionController,
                    onChanged: (text) {
                      _description = text;
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
                  Text(_startTime.format(context), textScaleFactor: 1, textAlign: TextAlign.left),
                  RaisedButton(
                      child: Text('Select'),
                      onPressed: () {
                        _getTimes();
                      })
                ],
              ),
            //End Time
            Container(
                  child: Text("End Time: " + _endTime.format(context),
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
    setState(() {
      _startTime = range.startTime;
      _endTime = range.endTime;
    });
  }

}