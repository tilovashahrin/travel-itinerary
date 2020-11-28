import 'package:flutter/material.dart';

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