import 'package:flutter/material.dart';
import 'edit_event.dart';
import 'trip_components/day.dart';
import 'trip_components/event.dart';
import 'event_notifications.dart';

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

  //temporary UI
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        leading: BackButton(onPressed: () => Navigator.pop(context, event)),  //return to event list with event
        actions: <Widget> [
        //edit event button
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _editEvent();
            }
          )
        ]
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child:
          //Event
            Container (
                  child: ListTile(
                  title: Text(event.name + " " + event.location),
                  subtitle: Text(event.startTime.format(context) + " to " + event.endTime.format(context)),
                  )
            )
        ),
      );
  }

  Future<void> _editEvent() async {
    //navigate to edit event page
    var e = await Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return EditEvent(day: eventDay, event: event);
      }));
    if (e != null){
      //user hasn't deleted event
      Event returnedEvent = e;
      //check if event has been changed
      if (!returnedEvent.isSameAs(event)){
        setState(() {
          event = returnedEvent;          
        });
      }
    }
    else {
    //user has chosen to delete event
      Navigator.pop(context, null);
    }
  }
}

