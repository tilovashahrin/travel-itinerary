import 'trip.dart';

//class to store list of user's trips
class TripList{
  //add user id when accounts implemented
  List<Trip> trips;

  TripList({this.trips});

  //sort trip list chronologically
  void orderTrips(){
    trips.sort((a,b){
    return a.startDate.compareTo(b.startDate);
    });
  }

  //check if trip being added conflicts with pre-existing trips
  bool timeSlotAvailable(Trip newTrip){
    //if there are no other trips, return true
    if (trips.length == 0){
      return true;
    }

    DateTime newStart = newTrip.startDate;
    DateTime newEnd = newTrip.endDate;   

    //iterate through trips to find conflicts
    for (int i = 0; i < trips.length; i++){
      //convert new event's times to DateTime instances
      DateTime tripStart = trips[i].startDate;
      DateTime tripEnd = trips[i].endDate;

      //case 1: new event happens during an event
      if ((newStart.isAtSameMomentAs(tripStart) || newStart.isAfter(tripStart))
            && (newEnd.isAtSameMomentAs(tripEnd) || newEnd.isBefore(tripEnd)) ){
        return false;
      }

      //case 2: new event ends after another starts, but starts before it
      if ((newEnd.isAfter(tripStart) || newEnd.isAtSameMomentAs(tripStart)) 
            && (tripStart.isAfter(newStart) || tripStart.isAtSameMomentAs(newStart))){
        return false;
      }
      
      //case 3: new trip starts before another ends, but ends after it starts
      if ((newStart.isBefore(tripEnd) || newStart.isAtSameMomentAs(tripEnd)) 
            && (newEnd.isAfter(tripStart) || newEnd.isAtSameMomentAs(tripStart))){
          return false;
      }
    }
    //none of the conflict cases apply, trip can be added
    return true;
  }
}