import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoding/geocoding.dart' as gc;

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
      //  Row( 
        //  children: [
        //    Icon(Icons.location_on_outlined, color: Colors.black),
            TextField(
              onSubmitted: (text) async {
                await searchForLocation(text);
              }
            ),
        //  ]
        //),
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
            //MarkerLayerOptions(markers: []),
          ],
        ),
          height: 0.8 * MediaQuery.of(context).size.height,

        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userSearch != null){
            Navigator.of(context).pop([userSearch, point]);
          }
        },
        child: Icon(Icons.save, color: Colors.black,),
        backgroundColor: Colors.white,
      ),
    );
  }

  Future <void> searchForLocation(String search) async {
      if (search != null){
      List<gc.Location> p = await gc.locationFromAddress(search);
      if (p.isNotEmpty) {
        userSearch = search;
        setState(() {
          point.latitude = p[0].latitude;
          point.longitude = p[0].longitude;
          _mapController.move(point, 10);
        });
      } else {
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
