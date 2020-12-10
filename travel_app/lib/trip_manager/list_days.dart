import 'package:flutter/material.dart';
import 'list_events.dart';
import 'edit_trip.dart';
import 'trip_components/trip.dart';
import 'trip_components/trip_list.dart';
import 'trip_components/day.dart';
// import 'local_storage/day_model/day_model.dart';
import 'utils.dart';

//Page to list each day of a trip. When a day is tapped the user will be shown a list of the day's event.

class DayList extends StatefulWidget {
  final String title;
  final Trip trip;
  final TripList tripList;
  DayList({Key key, this.title, this.trip, this.tripList}) : super(key: key);

  @override
  _DayListState createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  Trip _trip;
  TripList _tripList;
  List<Day> _days;
  // int _lastInsertedId = 0;
  // DayModel _model = new DayModel();

  void initState() {
    _trip = widget.trip;
    _tripList = widget.tripList;
    _days = widget.trip.days;
    super.initState();
  }

  //temporary UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(toDateString(_trip.startDate) + " - " + toDateString(_trip.endDate)),
          leading: BackButton(onPressed: () => Navigator.pop(context, _trip),),
          actions: <Widget> [
        //edit trip button
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _editTrip();
            }
          )
        ]
          ),
      body: Align(
        alignment: Alignment.topLeft,
        //List of days
        child:
              //  ListTile(
              //   title: Text(_trip.name + " " + _trip.location),
              //   subtitle: Text(toDateString(_trip.startDate) + " - " + toDateString(_trip.endDate)),
              //   ),

            ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: _days.length,
            itemBuilder: (BuildContext context, int index) {
              //day
              return GestureDetector(
                onTap: () {
                  _showEventList(_days[index], index);
                },
                child: Container(
                    child: ListTile(
                  title: Text(_days[index].dayString),
                  subtitle: Text("Tap to View Events"), //change to event count
                )),
              );
            },
          )
      ),
    );
  }

  Future<void> _showEventList(Day currentDay, int currentIndex) async {
    //navigate to list of events
    var e = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EventList(
          day: currentDay); //navigate to page with list of day's events
    }));
    setState(() {
      _days[currentIndex].events = e; //save any changes to events list
    });
    //_model.updateDay(_days[currentIndex]); //update day in database
  }

  Future<void> _editTrip() async {
    var t = await Navigator.push(context, MaterialPageRoute(builder: (context) {return EditTrip(tripList: _tripList, trip: _trip);}));
    if (t != null){
      Trip returnedTrip = t;
      if (returnedTrip.checkForDeletion()){
      //trip has been marked for deletion, return it to trip list page
        Navigator.pop(context, returnedTrip);
      }
      else {
        setState(() {
        _trip = returnedTrip;
        _days = _trip.days;
        });
      }
    }
  }

}
