import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:intl/intl.dart';

class Trip {
  List<Day> days = [];
  String name, description;
  String location; //change to list later for multiple locations? 
  DateTime startDate, endDate; //start and end date of trip
  int id; //id for databae

  //single placeholder image for testing UI
  //Image tripPhoto = Image.network("https://via.placeholder.com/600/771796");

  //constructor
  Trip({this.days, this.name, this.location, this.description, this.startDate, this.endDate, this.id});

  //initialize list of days in trip
  void initDays(){
    int dayCount = endDate.difference(startDate).inDays + 1; //get number of days trip is
    List<Day> tripDays = new List<Day>();
    DateTime dateTracker = startDate;
    for (int i = 1; i <= dayCount; i++){
      Day d = Day(dayNum: i, date: dateTracker);
      d.initDay();
      d.tripId = this.id;
      tripDays.add(d);
      dateTracker = new DateTime(dateTracker.year, dateTracker.month, dateTracker.day + 1); //increment day
    }
    this.days = tripDays;
  }

    //fromMap function
  Trip.fromMap(Map<String, dynamic> m){
    this.id = m['id'];
    this.name = m['name'];
    this.description = m['description'];
    this.location = m['location'];
    //convert strings back to dates
    this.startDate =  new DateFormat.yMMMd().parse(m['startDate']);
    this.endDate =  new DateFormat.yMMMd().parse(m['endDate']);
  }

  //toMap function
  Map<String, dynamic> toMap(){
    //convert dates to strings
    String startDateString = new DateFormat.yMMMd().format(startDate);
    String endDateString = new DateFormat.yMMMd().format(endDate);
    Map<String, dynamic> m = {
      'id' : id,
      'name' : name,
      'description' : description,
      'location' : location,
      'startDate' : startDateString,
      'endDate' : endDateString
    };
    return m;
  }

}

//Class for each day of a trip
class Day {
  DateTime date;
  List<Event> events = [];
  int dayNum; //day # of trip
  String dayString;
  int id, tripId; //ids for database 

  Day({this.date, this.events, this.dayNum, this.dayString, this.id, this.tripId});

  void initDay() {
    this.dayString = toDateString(date);
  }

  // void addEvent(Event event){
  //   event.date = this.date;
  //   events.add(event);
  //   //add verification that no events overlap
  // }

    Day.fromMap(Map<String, dynamic> m){
    this.id = m['id'];
    this.dayNum = m['dayNum'];
    this.dayString= m['dayString'];
    this.tripId = m['tripId'];
    //convert string back to dates
    this.date =  new DateFormat.yMMMd().parse(m['date']); 
  }

  //toMap function
  Map<String, dynamic> toMap(){
    //convert date to string
    String dateString = new DateFormat.yMMMd().format(date);
    Map<String, dynamic> m = {
      'id' : id,
      'dayNum' : dayNum,
      'dayString' : dayString,
      'tripId' : tripId,
      'date' : dateString,
    };
    return m;
  }

}

class Event {
  String name, location, description;
  TimeOfDay startTime, endTime; //start and end times of event, to be picked with timePicker
  //DateTime date;
  int id, dayId;

  //constructor
  Event({this.name, this.location, this.description, this.startTime, this.endTime, this.id, this.dayId});

   //fromMap function
  Event.fromMap(Map<String, dynamic> m){
    this.id = m['id'];
    this.name = m['name'];
    this.description = m['description'];
    this.location = m['location'];
    //convert strings back to dates
    this.startTime = _stringToTime(m['startTime']);
    this.endTime = _stringToTime(m['endTime']);
    this.dayId = m['dayId'];
  }

  //toMap function
  Map<String, dynamic> toMap(){
    //convert times to strings
    String startTimeString = startTime.toString();
    String endTimeString = endTime.toString();
    Map<String, dynamic> m = {
      'id' : id,
      'name' : name,
      'description' : description,
      'location' : location,
      'startTime' : startTimeString,
      'endTime' : endTimeString,
      'dayId' : dayId
    };
    return m;
  }

  TimeOfDay _stringToTime(String timeString){
    //get hour and minute string from TimeOfDay.toString value
    String hourString = timeString.substring(10,11);
    String minuteString = timeString.substring(13,14);
    //convert substrings to integers and create new TimeOfDay
    return new TimeOfDay(hour: int.parse(hourString), minute: int.parse(minuteString));
  }

}