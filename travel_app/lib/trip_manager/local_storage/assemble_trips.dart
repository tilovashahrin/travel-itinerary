import 'package:travel_app/trip_manager/trip_components/trip.dart';
import 'package:travel_app/trip_manager/trip_components/trip_list.dart';
import 'package:travel_app/trip_manager/trip_components/day.dart';
import 'package:travel_app/trip_manager/trip_components/event.dart';
import 'package:travel_app/trip_manager/local_storage/trip_model/trip_model.dart';
import 'package:travel_app/trip_manager/local_storage/day_model/day_model.dart';
import 'package:travel_app/trip_manager/local_storage/event_model/event_model.dart';

//function to match trips with days and days with events from databases

Future<TripList> assembleTrips() async {
  TripModel tripModel = new TripModel();
  var t = await tripModel.getAllTrips();

  DayModel dayModel = new DayModel();
  var d = await dayModel.getAllDays();

  EventModel eventModel = new EventModel();
  var e = await eventModel.getAllEvents();

  int daysFound = 0; //flag variable to check if Trip has days

  if (t == null){
    //no trips in database, return TripList with empty list of trips
    List<Trip> list = [];
    TripList trips = new TripList(trips: list);
    return (trips);
  }
  else{
    //loop for trips
    for (int i = 0; i < t.length; i++){
      List<Day> days = [];
      daysFound = 0;
      //loop for days
      for (int j = 0; j < d.length; j++){
        List<Event> events = [];
        //check if day's trip id matches current trip
        if (t[i].id == d[j].tripId){
          //loop for events
            for (int k = 0; k < e.length; k++){
            //check if event's day id matches current day
              if (d[j].id == e[k].dayId){
                //add event to event list
                events.add(e[k]);
              }
            }
          //set day's events and order them
          d[j].events = events;
          d[j].orderEvents();
          //add day to list
          days.add(d[j]);
          }
      }
      //set trip's days
      t[i].days= days;
    }

    TripList trips = new TripList(trips: t);
    trips.orderTrips();
    //return list of assembled trips
    return trips;
  }
}