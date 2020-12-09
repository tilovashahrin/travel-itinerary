import 'package:travel_app/trip_manager/trip_components/trip.dart';
import 'package:travel_app/trip_manager/trip_components/trip_list.dart';
import 'package:travel_app/trip_manager/trip_components/day.dart';
import 'package:travel_app/trip_manager/trip_components/event.dart';
import 'package:travel_app/trip_manager/local_storage/trip_model/trip_model.dart';
import 'package:travel_app/trip_manager/local_storage/day_model/day_model.dart';
import 'package:travel_app/trip_manager/local_storage/event_model/event_model.dart';
import 'package:travel_app/trip_manager/event_notifications.dart';

//functions to delete trip components and remove them from their database

Future<void> deleteTrip(Trip trip) async {
  TripModel tripModel = new TripModel();
  DayModel dayModel = new DayModel();
  EventModel eventModel = new EventModel();
  
}

Future<void> deleteDay(Day day) async {
  DayModel dayModel = new DayModel();
  EventModel eventModel = new EventModel();
  
}

Future<void> deleteEvent(Event event) async {
  final notifications = new EventNotifications();
  EventModel eventModel = new EventModel();

  //delete event from database
  await eventModel.deleteEvent(event.id);
  
  //delete notification for event if it exists
  // if (event.notificationId != null){
  // notifications.deleteNotification(event.notificationId);
  // }
}