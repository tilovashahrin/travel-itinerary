import 'package:flutter/material.dart';
import 'trip.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key key, this.title}) : super(key: key);

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
                        _getStartTime();
                      })
                ],
              ),
            //End Date
            Container(
                  child: Text("End Time: ",
                    textScaleFactor: 1, textAlign: TextAlign.left),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //display current selected time
                  Text(endTimeString, textScaleFactor: 1, textAlign: TextAlign.left),
                  RaisedButton(
                      child: Text('Select'),
                      onPressed: () {
                        _getEndTime();
                      })
                ],
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
              Navigator.of(context).pop(entry); //return new event
            }
            //show snackbar if some fields incomplete
            var snackbar = SnackBar(content: Text('Fill out all fields.'));
            Scaffold.of(context).showSnackBar(snackbar);           
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blue,
        )
      )
    );
  }

  //functions to call time picker and get times from user
  //add verification that endTime isn't before startTime
  Future<void> _getStartTime() async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0)
    ).then((value) {
      if (value != null) {
        startTime = value;
        setState(() {
          //change string formatting
          startTimeString= startTime.toString();
        });
      }
    });
  }

  Future<void> _getEndTime() async {
    await showTimePicker(
      context: context,
      initialTime: startTime
    ).then((value) {
      if (value != null) {
        endTime = value;
        setState(() {
          //change string formatting
          endTimeString= endTime.toString();
        });
      }
    });
  }

}