import 'package:flutter/material.dart';
import 'package:travel_app/trip_manager/trip_components/delete_components.dart';
import 'package:travel_app/trip_manager/trip_components/save_trips.dart';
import 'add_trip.dart';
import 'trip_components/trip.dart';
import 'trip_components/trip_list.dart';
//import 'trip_components/day.dart';
import 'utils.dart';
import 'list_days.dart';
import 'local_storage/assemble_trips.dart';

class ViewTripList extends StatefulWidget {
  ViewTripList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ViewTripListState createState() => _ViewTripListState();
}

class _ViewTripListState extends State<ViewTripList> {
  TripList _tripList = new TripList();
  // int _lastInsertedTripId = 0;
  // int _lastInsertedDayId = 0;
  int tripNum = 0;

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
        leading: BackButton(
          onPressed: () {
            //save changes to database
            saveTrips(_tripList);
            //return to main page
            Navigator.pop(context);
          }
        )
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
      newTrip.initDays();

      setState(() {
        _tripList.trips.add(newTrip);
        tripNum++;
        _tripList.orderTrips(); //re-sort trips
      });
    }
  }

  Future<void> _showDayList(Trip currentTrip, int currentIndex) async {
    var t = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return DayList(trip : currentTrip, tripList: _tripList,); //navigate to page with list of trip's days
      })
    );
    if (t != null){
      Trip returnedTrip = t;
      if (returnedTrip.checkForDeletion()) {
        //call function to delete from database
        await deleteTrip(currentTrip);
        //delete from this page's list
        setState(() {
        _tripList.trips.remove(currentTrip);
        tripNum = _tripList.trips.length;     
        });
      }
      else {
      setState(() {
        _tripList.trips[currentIndex] = returnedTrip;
      });
    }
  }
  }

}