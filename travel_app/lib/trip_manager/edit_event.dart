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
  String name, location, description;
  TimeOfDay startTime, endTime;
  Event updatedEvent;

  @override

  void initState() {
    updatedEvent = this.widget.event;
    name = this.widget.event.name;
    location = this.widget.event.location;  
    description = this.widget.event.description;
    startTime = this.widget.event.startTime;
    endTime = this.widget.event.endTime;
    _nameController = new TextEditingController(text: name);
    _locationController = new TextEditingController(text: location);
    _descriptionController = new TextEditingController(text: description);
    super.initState();
  }

  Widget build(BuildContext context) {
    final Event ogEvent = this.widget.event;

    return Scaffold(
      appBar: AppBar(
      title: Text("Edit Event"),
      leading: BackButton(onPressed: () => Navigator.pop(context, ogEvent)),
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
                            //return null to view event page
                            Navigator.pop(context, null);
                            Navigator.pop(context, null);
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
                    controller: _locationController,
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
                    controller: _descriptionController,
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
                  Text(startTime.format(context), textScaleFactor: 1, textAlign: TextAlign.left),
                  RaisedButton(
                      child: Text('Select'),
                      onPressed: () {
                        _getTimes();
                      })
                ],
              ),
            //End Time
            Container(
                  child: Text("End Time: " + endTime.format(context),
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
            //update event
              updatedEvent.name = name;
              updatedEvent.location = location;
              updatedEvent.description = description;
              updatedEvent.startTime = startTime;
              updatedEvent.endTime = endTime;
            //check if time conflicts with pre-existing events
              if (widget.day.timeSlotAvailable(updatedEvent)) {
                //no conflict, return event to event list
                Navigator.of(context).pop(updatedEvent);
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
      startTime = range.startTime;
      endTime = range.endTime;
    });
  }

}