import 'package:flutter/material.dart';
import 'trip_components/trip.dart';
import 'trip_components/trip_list.dart';
import 'utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'maps/select_location.dart';

class AddTrip extends StatefulWidget {
  AddTrip({Key key, this.title, this.tripList}) : super(key: key);
  final TripList tripList;
  final String title;

  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  String name, description;
  DateTime startDate, endDate;
  String startDateString = "No Date Chosen";
  String endDateString = "No Date Chosen";
  TripList _tripList;
  String location = "No Location Chosen";

  @override
  void initState() {
    _tripList = widget.tripList;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Create Trip",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            leading: BackButton(
              color: Colors.black,
              onPressed: () {
                  Navigator.pop(context);
              })
        ),

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            //Name of Trip
              Container(
                child: Text(
                  "Trip Name ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                width: 0.8 * MediaQuery.of(context).size.width,
                child: TextField(
                  //store text when textfield is edited
                  onChanged: (text) {
                  name = text;
                }),
              ),

            //Location
              Container(
                child: Text(
                  "Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    location,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  RaisedButton(
                    child: Text('Select'),
                    color: Colors.white,
                    onPressed: () {
                      getLocation();
                    }
                  )
                ],
              ),

              //Description
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text("Description",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                width: 0.8 * MediaQuery.of(context).size.width,
                child: TextField(onChanged: (text) {
                  description = text;
                }),
              ),

            //Date Selection
            //Start Date
              Container(
                child: Text(
                  "Start Date:    " + startDateString,
                  style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            //End Date
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                    "End Date:    " + endDateString,
                    style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

            //Select Dates button
              RaisedButton(
                  color: Colors.white,
                  child: Text('Select Dates'),
                  onPressed: () {
                    _getDates();
                  })
            ]),
          ),
        ),

        //Save button
        floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
                  onPressed: () {
                    //if all fields have been changed and dates have been selected
                    if (name != null &&
                        location != null &&
                        description != null &&
                        startDate != null &&
                        endDate != null) {
                      //create Trip instance
                      Trip entry = Trip(
                          name: name,
                          location: location,
                          description: description,
                          startDate: startDate,
                          endDate: endDate);

                      //check if dates conflict with other trips
                      if (_tripList.timeSlotAvailable(entry)) {
                        Navigator.of(context).pop(entry); //return new trip
                      } else {
                        //conflict, show dialogue
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Time Conflict'),
                              content: Text(
                                  'The dates of this trip conflict with another trip.'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Change Dates'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      //show snackbar if some fields incomplete
                      var snackbar =
                          SnackBar(content: Text('Fill out all fields.'));
                      Scaffold.of(context).showSnackBar(snackbar);
                    }
                  },
                  child: Icon(Icons.save, color: Colors.black),
                  backgroundColor: Colors.white,
                )));
  }

//function to call date range picker and get dates from user
  Future<void> _getDates() async {
    //get start date of trip
    List<DateTime> dates = await DateRangePicker.showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      initialFirstDate: DateTime.now(),
      initialLastDate: DateTime.now().add(new Duration(days: 7)),
    );
    if (dates != null && dates.length == 2) {
      startDate = dates[0];
      endDate = dates[1];
      setState(() {
        startDateString = toDateString(startDate) + " ${startDate.year}";
        endDateString = toDateString(endDate) + " ${endDate.year}";
      });
    }
  }

  Future<void> getLocation() async {
    var loc =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SelectLocation();
    }));
    if (loc != null) {
      setState(() {
        location = loc[0];
      });
    }
  }
}
