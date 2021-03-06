import 'package:flutter/material.dart';
import 'trip_components/trip.dart';
import 'trip_components/trip_list.dart';
import 'utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'maps/select_location.dart';

//Page to edit an existing trip

class EditTrip extends StatefulWidget {
  EditTrip({Key key, this.title, this.tripList, this.trip}) : super(key: key);
  final TripList tripList;
  final Trip trip;
  final String title;

  @override
  _EditTripState createState() => _EditTripState();
}

class _EditTripState extends State<EditTrip> {
  TextEditingController _nameController, _descriptionController;
  String name, location, description;
  String startDateString;
  String endDateString;
  DateTime startDate, endDate;
  Trip updatedTrip;
  bool datesChanged = false;

  @override
  void initState() {
    updatedTrip = widget.trip;
    name = updatedTrip.name;
    location = updatedTrip.location;
    description = updatedTrip.description;
    startDate = updatedTrip.startDate;
    endDate = updatedTrip.endDate;
    startDateString = toDateString(startDate) + " ${startDate.year}";
    endDateString = toDateString(endDate) + " ${endDate.year}";
    _nameController = new TextEditingController(text: name);
    _descriptionController = new TextEditingController(text: description);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Edit Trip",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
              ),
            leading: BackButton(
              color: Colors.black,
              onPressed: () => Navigator.pop(context, null)
            ),

            actions: <Widget>[
              //delete event button
              IconButton(
                  icon: Icon(Icons.delete, color: Colors.black,),
                  onPressed: () {
                    //show dialogue asking user to confirm deletion
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Trip?'),
                          //content: Text('Permanently delete event?'),
                          actions: <Widget>[
                            //confirm delete
                            FlatButton(
                              child: Text('Delete'),
                              onPressed: () {
                                Navigator.pop(context, null);
                                //mark trip for deletion
                                updatedTrip.markForDeletion();
                                //return trip to view event page
                                Navigator.pop(context, updatedTrip);
                              },
                            ),
                            //cancel delete
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context, null);
                              },
                            )
                          ],
                        );
                      },
                    );
                  }),
            ]),

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
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
                    controller: _nameController,
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
                  child: TextField(
                    controller: _descriptionController,
                    onChanged: (text) {
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
                  onPressed: () async {
                    //if all fields have been changed and times have been selected
                    if (name != null &&
                        location != null &&
                        description != null &&
                        startDate != null &&
                        endDate != null) {
                      //update event
                      updatedTrip.name = name;
                      updatedTrip.location = location;
                      updatedTrip.description = description;
                      updatedTrip.startDate = startDate;
                      updatedTrip.endDate = endDate;
                      //check if time conflicts with pre-existing events
                      if (widget.tripList.timeSlotAvailable(updatedTrip)) {
                        //no conflict, check if dates have been changed
                        if (datesChanged) {
                          //get correct trip days
                          var t = await reInitDays(updatedTrip, context);
                          if (t != null) {
                            //if trip has been returned
                            updatedTrip = t;
                            Navigator.of(context).pop(updatedTrip);
                          }
                        } else {
                          Navigator.of(context).pop(updatedTrip);
                        }
                      } else {
                        //conflict, show dialog telling user to pick a new time
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Time Conflict'),
                              content: Text(
                                  'The timing of this event conflicts with another event this day.'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Change Time'),
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
    datesChanged = true;
    //get start date of trip
    List<DateTime> dates = await DateRangePicker.showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      initialFirstDate: DateTime.now(),
      initialLastDate: DateTime.now().add(new Duration(days:  7)),
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

  //function to get the trip's new list of days
  Future<Trip> reInitDays(Trip t, BuildContext context) async {
    int oldDayNum = t.days.length;
    //create new trip to get new number of days without overwriting old days
    Trip newTrip = t;
    newTrip.initDays();
    int newDayNum = newTrip.days.length;
    if (newDayNum < oldDayNum) {
      //days will be deleted, warn user with dialogue
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Days?'),
            content: Text('Events on days after Day $newDayNum of the trip will be deleted.'),
            actions: <Widget>[
              //confirm delete
              FlatButton(
                child: Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                  t.shortenTrip();
                  return t;
                },
              ),
              //cancel delete
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
    else {
    //days will be added or number will stay the same
      t.lengthenTrip();
      return t;
    }
    return null;
  }

    Future<void> getLocation() async {
    var loc = await Navigator.push(context, MaterialPageRoute(builder: (context) {return SelectLocation();}));
    if (loc != null) {
      setState(() {
        location = loc[0];
      });
    }
  }
}
