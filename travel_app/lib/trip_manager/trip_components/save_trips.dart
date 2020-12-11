import 'package:travel_app/trip_manager/trip_components/trip_list.dart';
import 'package:travel_app/trip_manager/trip_components/trip.dart';
import 'package:travel_app/trip_manager/trip_components/day.dart';
import 'package:travel_app/trip_manager/trip_components/event.dart';
import 'package:travel_app/trip_manager/local_storage/trip_model/trip_model.dart';
import 'package:travel_app/trip_manager/local_storage/day_model/day_model.dart';
import 'package:travel_app/trip_manager/local_storage/event_model/event_model.dart';

// Function to save all trips and their components (days and events) into local storage

Future<void> saveTrips(TripList tripList) async {
  TripModel tripModel = new TripModel();
  DayModel dayModel = new DayModel();
  EventModel eventModel = new EventModel();
  int lastInsertedTripId = 0;
  int lastInsertedDayId = 0;
  int lastInsertedEventId = 0;
  List<Trip> trips = tripList.trips;

  //iterate through trips
  for (int i = 0; i < trips.length; i++){
    //update trip or insert it into the database
    if (trips[i].id != null){
      tripModel.updateTrip(trips[i]);
    }
    else {
      lastInsertedTripId = await tripModel.insertTrip(trips[i]);
      trips[i].id = lastInsertedTripId;
    }
    //iterate through trip's days
    List<Day> days = trips[i].days;
    for (int j = 0; j < days.length; j++){
      days[j].tripId = trips[i].id;
      //update day or insert it into the database
      if (days[j].id != null){
        dayModel.updateDay(days[j]);
      }
      else {
        lastInsertedDayId = await dayModel.insertDay(days[j]);
        days[j].id = lastInsertedDayId;
      }
      //iterate through day's events
      List<Event> events = days[j].events;
      for (int k = 0; k < events.length; k++){
        events[k].dayId = days[j].id;
        //update event or insert it into the database
        if (events[k].id != null){
          eventModel.updateEvent(events[k]);
        }
        else {
          lastInsertedEventId = await eventModel.insertEvent(events[k]);
          events[k].id = lastInsertedEventId;
        }
      }
      
    }
  }
}