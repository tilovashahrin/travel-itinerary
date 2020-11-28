import 'day.dart';
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



