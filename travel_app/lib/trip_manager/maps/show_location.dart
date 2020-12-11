import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoding/geocoding.dart' as gc;

//Page to show an event's location on a map

class ShowLocation extends StatefulWidget {
  ShowLocation({Key key, this.title, this.address}) : super(key: key);
  final String address;
  final String title;

  @override
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
  String _address;
  MapController _mapController;
  LatLng eventLoc;
  Marker pointMark;

  @override
  void initState() {
      super.initState();
      _mapController = MapController();
      _address = this.widget.address;
      setPoint(_address);
    }


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_address, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context)
        )
      ),
      body:FlutterMap(
      options: MapOptions(
        zoom: 15,
        center: eventLoc,
      ),
      mapController: _mapController,
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
      ],
    )
    );
  }

  Future<void> setPoint(String loc) async {
    //get coordinates of event's location
    List<gc.Location> p = await gc.locationFromAddress(loc);
    if (p.isNotEmpty) {
      eventLoc = new LatLng(p[0].latitude, p[0].longitude);
    }
}
}
