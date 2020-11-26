import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:intl/intl.dart';

class Trip {
  //add user id when accounts implemented
  List<Day> days = [];
  String name, description;
  String location; //change to list later for multiple locations? 
  DateTime startDate, endDate; //start and end date of trip
  int id; //id for databae

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
      d.initEventList();
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
  List<Event> events;
  int dayNum; //day # of trip
  String dayString;
  int id, tripId; //ids for database 

  Day({this.date, this.events, this.dayNum, this.dayString, this.id, this.tripId});

  void initDay() {
    this.dayString = toDateString(date);
  }

  void initEventList(){
    this.events = [];
  }

  //sort events from first to last occuring
  void orderEvents(){
    events.sort((a,b){
      //convert event start times to DateTime to compare them
      DateTime aDate =  DateTime.now().add( Duration(hours: a.startTime.hour, minutes: a.startTime.minute));
      DateTime bDate =  DateTime.now().add( Duration(hours: b.startTime.hour, minutes: b.startTime.minute));
      return aDate.compareTo(bDate);
    });
  }

  //check if a new event overlaps with any pre-existing events
  bool timeSlotAvailable(Event newEvent){

    //if there are no other events added yet, return true
    if (events.length == 0){
      return true;
    }

    //convert new event's times to DateTime instances
    DateTime newStart =  DateTime.now().add( Duration(hours: newEvent.startTime.hour, minutes: newEvent.startTime.minute));
    DateTime newEnd =  DateTime.now().add( Duration(hours: newEvent.endTime.hour, minutes: newEvent.endTime.minute));   

    //iterate through day's current events to find conflicts
    for (int i = 0; i < events.length; i++){
      //convert new event's times to DateTime instances
      DateTime eventStart = DateTime.now().add( Duration(hours: events[i].startTime.hour, minutes: events[i].startTime.minute));
      DateTime eventEnd = DateTime.now().add( Duration(hours: events[i].endTime.hour, minutes: events[i].endTime.minute));

      //case 1: new event happens during an event
      if ((newStart.isAtSameMomentAs(eventStart) || newStart.isAfter(eventStart))
            && (newEnd.isAtSameMomentAs(eventEnd) || newEnd.isBefore(eventEnd)) ){
        return false;
      }

      //case 2: new event ends after another starts, but starts before it
      if ((newEnd.isAfter(eventStart) || newEnd.isAtSameMomentAs(eventStart)) 
            && (eventStart.isAfter(newStart) || eventStart.isAtSameMomentAs(newStart))){
        return false;
      }
      
      //case 3: new event starts before another ends, but ends after it starts
      if ((newStart.isBefore(eventEnd) || newStart.isAtSameMomentAs(eventEnd)) 
            && (newEnd.isAfter(eventStart) || newEnd.isAtSameMomentAs(eventStart))){
          return false;
      }
    }
    //none of the conflict cases apply, event can be added
    return true;
  }

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
    String hourString = timeString.substring(10,12);
    String minuteString = timeString.substring(13,15);
    //convert substrings to integers and create new TimeOfDay
    return new TimeOfDay(hour: int.parse(hourString), minute: int.parse(minuteString));
  }

}