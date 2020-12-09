import 'package:intl/intl.dart';
import 'event.dart';
import 'package:travel_app/trip_manager/utils.dart';

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

  //check if a new/edited event overlaps with any pre-existing events
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
      
      if (newEvent.id == events[i].id){
        //if current event is the same event being checked, skip iteration
        continue;
      }

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