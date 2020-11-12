import 'package:flutter/material.dart';
import 'add_event.dart';
import 'trip.dart';

class EventList extends StatefulWidget {
  EventList({Key key, this.title, this.day}) : super(key: key);
  final Day day;
  final String title;

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<Event> _events = [];
  int eventNum;
  //temporary UI
  @override
  Widget build(BuildContext context) {
    if (widget.day.events != null){
    _events = widget.day.events;
    }
    if (_events != null){
    eventNum = _events.length;
    }
    else {
      eventNum = 0;
    }
    return Scaffold(
      appBar: AppBar(
        //add date to title
        title: Text("Schedule"),
        leading: BackButton(onPressed: () => Navigator.pop(context, _events),)  //return with current events
        ),
      body: Align(
        alignment: Alignment.topLeft,
        //List of entities
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: eventNum,
          itemBuilder: (BuildContext context, int index) {
            //Event
            //temporary widget, change to custom later w/time displayed + event selection
            return Container (
                  child: ListTile(
                  title: Text(_events[index].name + " " + _events[index].location),
                  subtitle: Text(_events[index].startTime.toString() + " to " + (_events[index].endTime.toString())),
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

  Future<void> _addEvent() async {
    //navigate to grade form page
    var e = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AddEvent();
        }));
    if (e != null){ 
      //if user enters event
      Event newEvent = e;
      setState(() {
        _events.add(newEvent);
        widget.day.events = _events;
      });
    }
  }


}