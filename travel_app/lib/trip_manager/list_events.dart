import 'package:flutter/material.dart';
import 'add_event.dart';
import 'view_event.dart';
import 'trip_components/day.dart';
import 'trip_components/event.dart';
//import 'local_storage/event_model/event_model.dart';
import 'event_notifications.dart';
import 'trip_components/delete_components.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class EventList extends StatefulWidget {
  EventList({Key key, this.title, this.day}) : super(key: key);
  final Day day;
  final String title;

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  int eventNum = 0;
  //int _lastInsertedId = 0;
  //EventModel _model = new EventModel();
  final _notifications = new EventNotifications();
  Day eventsDay;
  
  void initState() {
    eventsDay = widget.day;
    if (eventsDay.events != null){
    eventNum = eventsDay.events.length;
    }
    super.initState();
  }

  //temporary UI
  @override
  Widget build(BuildContext context) {
    _notifications.init();
    tz.initializeTimeZones();
    
    return Scaffold(
      appBar: AppBar(
        //add date to title
        title: Text("Schedule"),
        leading: BackButton(onPressed: () => Navigator.pop(context, eventsDay.events),)  //return with current events
        ),
      body: Align(
        alignment: Alignment.topLeft,
        //List of events
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: eventNum,
          itemBuilder: (BuildContext context, int index) {
          //Event
            //temporary widget, change to custom later w/time displayed + event selection
            return GestureDetector(
              onTap: () {
               _showEventView(eventsDay.events[index], index);
              },
              child: Container (
                  child: ListTile(
                  title: Text(eventsDay.events[index].name + " " +eventsDay.events[index].location),
                  subtitle: Text(eventsDay.events[index].startTime.format(context) + " to " + eventsDay.events[index].endTime.format(context)),
                  )
            )
            );
          },
        ),
      ),

    //Add Event Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEvent();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      )
    );
  }

  Future<void> _showEventView(Event event, int index) async {
    //navigate to view event page
    var e = await Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return ViewEvent(day: eventsDay, event: event);
      }));
    
    if (e != null){
      //event has been returned
      Event returnedEvent = e;
      if (returnedEvent.checkForDeletion()) {
        //user chose to delete event
        _deleteEvent(event);
      }
      else if (!returnedEvent.isSameAs(event)){
      //event has been modified
        //replace event notification
          // _notifications.deleteNotification(event.notificationId);
          // returnedEvent.notificationId = await _addEventNotification(returnedEvent, eventsDay.date);
        //update database
       // await _model.updateEvent(returnedEvent);
        //update event list and set state
        setState(() {
        eventsDay.events[index] = returnedEvent; //replace event in list
        eventsDay.orderEvents(); //resort order of list
        });
      }
    }
  }

  Future<void> _addEvent() async {
    //navigate to add event page
    var e = await Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return AddEvent(day: eventsDay);
      }));
    if (e != null){
      //if user enters event
      Event newEvent = e;
      newEvent.dayId = eventsDay.id;
      //create notification for event
      newEvent.notificationId = await _addEventNotification(newEvent, eventsDay.date);
      //insert new event into database
      //_lastInsertedId = await _model.insertEvent(newEvent);
     // newEvent.id = _lastInsertedId;
      setState(() {
        eventsDay.events.add(newEvent); //add event to list
        eventsDay.orderEvents(); //resort order of list
        eventNum = eventsDay.events.length;
      });
    }
  }

  Future<int> _addEventNotification(Event e, DateTime date) async {
     tz.setLocalLocation(tz.getLocation('America/Detroit')); //hardcode local location until geocoding implemented
    var when = tz.TZDateTime(tz.local, date.year, date.month, date.day, e.startTime.hour, e.startTime.minute - e.notificationTime);
    var n = await _notifications.sendNotificationLater(e.name, e.description, when, null);
    return n;
  }

  //function to delete event
  Future<void> _deleteEvent(Event event) async {
    //call delete function from delete_components.dart
    deleteEvent(event);
    //remove from event list and set state
    setState(() {
        eventsDay.events.remove(event);
        eventNum = eventsDay.events.length;
    });
  }

}

