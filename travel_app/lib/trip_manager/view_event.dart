import 'package:flutter/material.dart';
import 'edit_event.dart';
import 'trip_components/day.dart';
import 'trip_components/event.dart';
import 'maps/show_location.dart';

//Page to view and edit the details of a single event

class ViewEvent extends StatefulWidget {
  ViewEvent({Key key, this.title, this.day, this.event}) : super(key: key);
  final Day day;
  final Event event;
  final String title;

  @override
  _ViewEventState createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  Day eventDay;
  Event event;

  void initState() {
    eventDay = widget.day;
    event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: BackButton(
              color: Colors.black,
               //when pressedreturn to event list with event
              onPressed: () => Navigator.pop(context, event)
            ),
            actions: <Widget>[
            //edit event button
              IconButton(
                  icon: Icon(Icons.settings, color: Colors.black,),
                  onPressed: () {
                    _editEvent();
                  })
            ]),
        body: Align(
            alignment: Alignment.topLeft,
            child:
                //Event
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.blue.withOpacity(0.1)),
                    padding:
                        EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
                    child: Column(
                      children: [
                        //Event name
                        Container(
                            child: Text(event.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25))),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                                event.startTime.format(context) +
                                    " to " +
                                    event.endTime.format(context),
                                style: TextStyle(fontSize: 18))),
                        //Location
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(event.location,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            RaisedButton(
                                child: Text('View on Map'),
                                color: Colors.white,
                                onPressed: () {
                                  //navigate to show_location page
                                  Navigator.push(context,MaterialPageRoute(builder: (context) {
                                    return ShowLocation(address: event.location);
                                  }));
                                })
                          ],
                        )),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(event.description,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ))));
  }

  Future<void> _editEvent() async {
    //navigate to edit event page
    var e = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditEvent(day: eventDay, event: event);
    }));
    if (e != null) {
      //user has changed event
      Event returnedEvent = e;
      //check if event has been marked for deletion
      if (returnedEvent.checkForDeletion()) {
        //return to event list with event
        Navigator.pop(context, returnedEvent);
      } else {
        //update page to show changed event
        setState(() {
          event = returnedEvent;
        });
      }
    }
  }
}
