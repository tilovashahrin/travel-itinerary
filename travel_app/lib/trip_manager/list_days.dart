import 'package:flutter/material.dart';
import 'list_events.dart';
import 'trip.dart';
import 'utils.dart';

//Page to list each day of a trip. When a day is tapped the user will be shown a list of the day's event.

class DayList extends StatefulWidget {
  final String title;
  final Trip trip;
  DayList({Key key, this.title, this.trip}) : super(key: key);

  @override
  _DayListState createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  List<Day> _days;
  //temporary UI
  @override
  Widget build(BuildContext context) {
    _days = widget.trip.days;    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.name + " Days"),
        leading: BackButton(onPressed: () => Navigator.pop(context, _days),)  //return with current days
        ),
      body: Align(
        alignment: Alignment.topLeft,
        //List of days
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: _days.length,
          itemBuilder: (BuildContext context, int index) {
            //day
            return GestureDetector(
              onTap: () {
                _showEventList(_days[index], index);
              },
              child: Container (
                child: ListTile(
                title: Text(_days[index].dayString),
                subtitle: Text("Tap to View Events"), //change to event count
                )
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showEventList(Day currentDay, int currentIndex) async {
    //navigate to list of events
    var e = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EventList(day : currentDay); //navigate to page with list of day's events
      }));
    setState(() {
      _days[currentIndex].events = e; //save any changes to events list
    });
  }
}