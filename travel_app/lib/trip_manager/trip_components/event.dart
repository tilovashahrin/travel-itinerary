import 'package:flutter/material.dart';

class Event {
  String name, location, description;
  TimeOfDay startTime, endTime; //start and end times of event
  //DateTime date;
  int id, dayId, notificationId;
  int notificationTime = 5; //REMOVE VALUE WHEN PICKER FOR NOTIFICATION TIME ADDED
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
    this.notificationId = m['notificationId'];
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
      'dayId' : dayId,
      'notificationId' : notificationId
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

  //function to check if event is the same as another
  bool isSameAs(Event e){
    if (this.name != e.name){return false;}
    if (this.description != e.description){return false;}
    if (this.location != e.location){return false;}
    if (this.dayId != e.dayId){return false;}

    //compare start and end times
    DateTime eventStart = DateTime.now().add( Duration(hours: this.startTime.hour, minutes: this.startTime.minute));
    DateTime eventEnd = DateTime.now().add( Duration(hours: this.endTime.hour, minutes: this.endTime.minute));
    DateTime otherStart = DateTime.now().add( Duration(hours: e.startTime.hour, minutes: e.startTime.minute));
    DateTime otherEnd = DateTime.now().add( Duration(hours: e.endTime.hour, minutes: e.endTime.minute));
    if (!(otherStart.isAtSameMomentAs(eventStart))){
      return false;
    }
    if (!(otherEnd.isAtSameMomentAs(eventEnd))){
      return false;
    }

    //events are identical, return true
    return true;
  }

}