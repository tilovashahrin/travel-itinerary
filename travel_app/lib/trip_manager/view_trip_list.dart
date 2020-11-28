import 'package:flutter/material.dart';
import 'add_trip.dart';
import 'trip_components/trip.dart';
import 'trip_components/trip_list.dart';
import 'utils.dart';
import 'list_days.dart';
import 'local_storage/trip_model/trip_model.dart';
import 'local_storage/day_model/day_model.dart';
import 'local_storage/assemble_trips.dart';

class ViewTripList extends StatefulWidget {
  ViewTripList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ViewTripListState createState() => _ViewTripListState();
}

class _ViewTripListState extends State<ViewTripList> {
  TripList _tripList = new TripList();
  int _lastInsertedTripId = 0;
  int _lastInsertedDayId = 0;
  int tripNum = 0;
  TripModel _tripModel = new TripModel();
  DayModel _dayModel = new DayModel();

  @override
  void initState() {
    _getTrips();

    super.initState();
  }

  //temporary UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Trips"),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        //List of trips
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: tripNum,
          itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                _showDayList(_tripList.trips[index], index);
              },
            child: Container (
                  child: ListTile(
                  title: Text(_tripList.trips[index].name + " " + _tripList.trips[index].location),
                  subtitle: Text(toDateString(_tripList.trips[index].startDate) + " - " + toDateString(_tripList.trips[index].endDate)),
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

  //get trips from local storage
  Future<void> _getTrips() async {
    var t = await assembleTrips();
    setState(() {
      _tripList = t;
      if(_tripList.trips != null){
      tripNum = _tripList.trips.length;
    }
    });
  }

  Future<void> _addTrip() async {
    var e = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AddTrip(tripList: _tripList);
      }));

    if (e != null){ 
      //if user enters trip
      Trip newTrip = e;

      //insert new trip into database
      _lastInsertedTripId = await _tripModel.insertTrip(newTrip);
      newTrip.id = _lastInsertedTripId;
      //insert days created by trip into database
      newTrip.initDays();
      for (int i = 0; i < newTrip.days.length; i++){
        _lastInsertedDayId = await _dayModel.insertDay(newTrip.days[i]);
        newTrip.days[i].id = _lastInsertedDayId;
      }
      setState(() {
        _tripList.trips.add(newTrip);
        tripNum++;
        _tripList.orderTrips(); //re-sort trips
      });
    }
  }

  Future<void> _showDayList(Trip currentTrip, int currentIndex) async {
    var d = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return DayList(trip : currentTrip); //navigate to page with list of trip's days
      })
    );

      //save any changes to days
      for (int i = 0; i < d.length; i++){
        d[i].id =_tripList.trips[currentIndex].days[i].id;
        _dayModel.updateDay(d[i]);
      }
    setState(() {
      _tripList.trips[currentIndex].days = d;
    });
  }

}