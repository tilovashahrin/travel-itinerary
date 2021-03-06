import 'package:travel_app/trip_manager/trip_components/trip.dart';
import 'package:travel_app/trip_manager/trip_components/day.dart';
import 'package:travel_app/trip_manager/trip_components/event.dart';
import 'package:travel_app/trip_manager/local_storage/trip_model/trip_model.dart';
import 'package:travel_app/trip_manager/local_storage/day_model/day_model.dart';
import 'package:travel_app/trip_manager/local_storage/event_model/event_model.dart';

//functions to delete trip components and remove them from their database

Future<void> deleteTrip(Trip trip) async {
  TripModel tripModel = new TripModel();

  //delete trip's days from database
  for (int i = 0; i < trip.days.length; i++){
    deleteDay(trip.days[i]);
  }
  //delete trip
  if (trip.id != null){
    await tripModel.deleteTrip(trip.id);
  }
}

Future<void> deleteDay(Day day) async {
  DayModel dayModel = new DayModel();

  //delete day's event from database
  for (int i = 0; i < day.events.length; i++){
    deleteEvent(day.events[i]);
  }
  if (day.id != null){
    //delete day
    await dayModel.deleteDay(day.id);
  }
}

Future<void> deleteEvent(Event event) async {
  EventModel eventModel = new EventModel();

  //delete event from database
  if (event.id != null){
    await eventModel.deleteEvent(event.id);
  }
}