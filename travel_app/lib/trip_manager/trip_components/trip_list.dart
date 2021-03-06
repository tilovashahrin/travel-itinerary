import 'trip.dart';

//class to store list of user's trips
class TripList{
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

    //iterate through list of trips
    for (int i = 0; i < trips.length; i++){

      if (newTrip.id == trips[i].id){
        //if current trip is the same trip being checked, skip iteration (only applies when a trip is being edited)
        continue;
      } 

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