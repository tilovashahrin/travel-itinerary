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
import 'package:geocoding/geocoding.dart' as gc;

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
        backgroundColor: Colors.white,
        title: Text(
          eventsDay.dayString,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
        ),
        leading: BackButton(onPressed: () => Navigator.pop(context, eventsDay.events), color: Colors.black,)  //return with current events
        ),
      body: Align(
        alignment: Alignment.topLeft,
        //List of events
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: eventNum,
          itemBuilder: (BuildContext context, int index) {
          //Event
            return GestureDetector(
              onTap: () {
               _showEventView(eventsDay.events[index], index);
              },
              child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: buildEvent(context, eventsDay.events[index]) 
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
        child: Icon(Icons.add, color: Colors.black,),
        backgroundColor: Colors.white,
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
      setState(() {
        eventsDay.events.add(newEvent); //add event to list
        eventsDay.orderEvents(); //resort order of list
        eventNum = eventsDay.events.length;
      });
    }
  }

  Future<int> _addEventNotification(Event e, DateTime date) async {
    // gc.Location l = new gc.Location(latitude: e.lat, longitude: e.lng);
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

    Widget buildEvent(BuildContext context, Event e) {
    return Container (
      decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),),
        //border: Border.all(color: Colors.black),
        color: Colors.blue.withOpacity(0.1)
        ),
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      child: Column(
      children: [
        //Trip name
        Container(
            child: Text(e.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        //Location
        Container(
            child: Text(
              e.location,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)
              ),
              alignment: Alignment.topLeft),
        Container(
            child: Text(
              e.startTime.format(context) + " to " + e.endTime.format(context),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,)
            ),
            alignment: Alignment.topLeft),
        Container(
            child: Text(
              e.description,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14)
            ),
            alignment: Alignment.topLeft),
      ],
    )
    );
  }

}

