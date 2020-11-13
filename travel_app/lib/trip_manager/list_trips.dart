import 'package:flutter/material.dart';
import 'add_trip.dart';
import 'trip.dart';
import 'utils.dart';
import 'list_days.dart';
import 'local_storage/trip_model/trip_model.dart';

class TripList extends StatefulWidget {
  TripList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<Trip> _trips = [];
  int _selectedIndex = -1;
  int _lastInsertedId = 0;
  TripModel _model = new TripModel();

  //temporary UI
  @override
  Widget build(BuildContext context) {
    _getTrips();
    return Scaffold(
        appBar: AppBar(
          title: Text("Scheduled Trips"), //add date to title
        ),
        body: Align(
          alignment: Alignment.topLeft,
          //List of trips
          child: ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: _trips.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    _showDayList(_trips[index], index);
                  },
                  child: Container (
                      child: ListTile(
                        title: Text(_trips[index].name + " " + _trips[index].location),
                        subtitle: Text(toDateString(_trips[index].startDate) + " - " + toDateString(_trips[index].endDate)),
                      )
                  )
              );
            },
          ),
        ),

        //Add Trip Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTrip();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        )
    );
  }

  Future<void> _getTrips() async {
    var t = await _model.getAllTrips();
    setState(() {_trips = t;});
  }

  Future<void> _addTrip() async {
    var e = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return AddTrip();
        }));
    if (e != null){
      //if user enters trip
      Trip newTrip = e;
      //insert new trip into database
      _lastInsertedId = await _model.insertTrip(newTrip);
      setState(() {
        _trips.add(newTrip);
      });
    }
  }

  Future<void> _showDayList(Trip currentTrip, int currentIndex) async {
    var d = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return DayList(trip : currentTrip); //navigate to page with list of trip's days
        }));
    setState(() {
      _trips[currentIndex].days = d; //save any changes to days
    });
  }

}