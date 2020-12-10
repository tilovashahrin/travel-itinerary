import 'day.dart';
import 'package:intl/intl.dart';
import 'delete_components.dart';

class Trip {
  //add user id when accounts implemented
  List<Day> days = [];
  String name, description;
  String location; //change to list later for multiple locations? 
  DateTime startDate, endDate; //start and end date of trip
  int id; //id for databae
  bool _toBeDeleted = false;

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

  void markForDeletion(){
    this._toBeDeleted = true;
  }

  bool checkForDeletion(){
    return _toBeDeleted;
  }

  void shortenTrip(){
    List<Day> oldDays = this.days;
    this.initDays();
    for (int i = 0; i < this.days.length; i++){
      this.days[i].events = oldDays[i].events;
      this.days[i].id = oldDays[i].id;
    }
    for (int i = this.days.length; i < oldDays.length; i++){
      //delete leftover days from database
      deleteDay(oldDays[i]);
    }
  }

  void lengthenTrip(){
    List<Day> oldDays = this.days;
    this.initDays();
    for (int i = 0; i < oldDays.length; i++){
      this.days[i].events = oldDays[i].events;
      this.days[i].id = oldDays[i].id;
    }    
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



