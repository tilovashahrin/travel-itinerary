import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoding/geocoding.dart' as gc;

// Page for user to select a trip/event's location and then be shown the location on the map

class SelectLocation extends StatefulWidget {
  SelectLocation({Key key}) : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  MapController _mapController;
  LatLng point;
  String userSearch;

  @override
  void initState() {
    super.initState();
    point = new LatLng(0, 0);
    _mapController = MapController();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Location", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context, null)
        )
      ),
      body: Column(children: [
        //Search bar for locations
            TextField(
              onSubmitted: (text) async {
                await searchForLocation(text);
              }
            ),
        Container(
            child: FlutterMap(
          options: MapOptions(
            zoom: 2,
            center: point,
          ),
          mapController: _mapController,
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
          height: 0.8 * MediaQuery.of(context).size.height,
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //if a location has been found
          if (userSearch != null){
            //return to previous page (an add or edit page for a trip/event)
            Navigator.of(context).pop([userSearch, point]);
          }
        },
        child: Icon(Icons.save, color: Colors.black,),
        backgroundColor: Colors.white,
      ),
    );
  }

  Future <void> searchForLocation(String search) async {
    //if a location has been searched
      if (search != null){
        //get location
        List<gc.Location> p = await gc.locationFromAddress(search);
        if (p.isNotEmpty) {
          //location found, move map to location
          userSearch = search;
          setState(() {
            point.latitude = p[0].latitude;
            point.longitude = p[0].longitude;
            _mapController.move(point, 10);
          });
      } else {
        //no place found, show dialog
        await showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Invalid Location'),
                      content: Text(
                          'No location found, try another search.'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Okay'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
      }
    }
  }
}
