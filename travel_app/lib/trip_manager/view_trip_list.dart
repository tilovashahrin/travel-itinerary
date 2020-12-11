import 'package:flutter/material.dart';
import 'package:travel_app/trip_manager/trip_components/delete_components.dart';
import 'package:travel_app/trip_manager/trip_components/save_trips.dart';
import 'add_trip.dart';
import 'trip_components/trip.dart';
import 'trip_components/trip_list.dart';
import 'utils.dart';
import 'list_days.dart';
import 'local_storage/assemble_trips.dart';

//Page to view all created trips. When a trip is tapped the user will be shown a list of its days.

class ViewTripList extends StatefulWidget {
  ViewTripList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ViewTripListState createState() => _ViewTripListState();
}

class _ViewTripListState extends State<ViewTripList> {
  TripList _tripList = new TripList();
  int tripNum = 0;

  @override
  void initState() {
    _getTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Your Trips",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            leading: BackButton(
                color: Colors.black,
                onPressed: () {
                  //save changes to database
                  saveTrips(_tripList);
                  //return to main page
                  Navigator.pop(context);
                })),
                
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
                  child:
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: buildTrip(context, _tripList.trips[index]) 
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
          child: Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.white,
        ));
  }

  //get trips from local storage
  Future<void> _getTrips() async {
    var t = await assembleTrips();
    setState(() {
      _tripList = t;
      if (_tripList.trips != null) {
        tripNum = _tripList.trips.length;
      }
    });
  }

  Future<void> _addTrip() async {
    var e = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTrip(tripList: _tripList);
    }));

    if (e != null) {
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
    var t = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DayList(
        trip: currentTrip,
        tripList: _tripList,
      ); //navigate to page with list of trip's days
    }));
    if (t != null) {
      Trip returnedTrip = t;
      if (returnedTrip.checkForDeletion()) {
        //call function to delete from database
        await deleteTrip(currentTrip);
        //delete from this page's list
        setState(() {
          _tripList.trips.remove(currentTrip);
          tripNum = _tripList.trips.length;
        });
      } else {
        setState(() {
          _tripList.trips[currentIndex] = returnedTrip;
        });
      }
    }
  }

  Widget buildTrip(BuildContext context, Trip t) {
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
            child: Text(t.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        //Location
        Container(
            child: Text(
              t.location,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)
              ),
              alignment: Alignment.topLeft),
        Container(
            child: Text(
              toDateString(t.startDate) + " - " + toDateString(t.endDate),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,)
            ),
            alignment: Alignment.topLeft),
        Container(
            child: Text(
              t.description,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14)
            ),
            alignment: Alignment.topLeft),
      ],
    )
    );
  }
}
