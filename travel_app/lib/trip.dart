import 'package:flutter/material.dart';
import 'utils.dart';

class Trip {
  List<Day> days;
  String name, description;
  String location; //change to list later for multiple locations? 
  DateTime startDate, endDate; //start and end date of trip
  //single placeholder image for testing UI
  Image tripPhoto = Image.network("https://via.placeholder.com/600/771796");

  //constructor
  Trip({this.days, this.name, this.location, this.description, this.startDate, this.endDate});

  //initialize list of days in trip
  void initDays(){
    int dayCount = endDate.difference(startDate).inDays + 1; //get number of days trip is
    List<Day> days = List<Day>();
    DateTime dateTracker = startDate;
    for (int i = 1; i <= dayCount; i++){
      Day d = Day(dayNum: i, date: dateTracker);
      days.add(d);
      dateTracker = new DateTime(dateTracker.year, dateTracker.month, dateTracker.day + 1); //increment day
    }
  }

}

class Day {
  DateTime date;
  List<Event> events = [];
  int dayNum; //day # of trip
  String dayString;

  Day({this.date, this.events, this.dayNum, this.dayString});

  void initDay() {
    dayString = toDateString(date);
  }

  void addEvent(Event event){
    events.add(event);
    //add verification that no events overlap
  }

}

class Event {
  String name, location, description;
  TimeOfDay startTime, endtime; //start and end times of event, to be picked with timePicker
  DateTime date;

  //constructor
  Event({this.name, this.location, this.description, this.startTime, this.endtime, this.date});
}