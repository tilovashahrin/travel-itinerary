import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as gc;

class ShowLocation extends StatefulWidget {
  ShowLocation({Key key, this.title, this.address}) : super(key: key);
  final String address;
  final String title;

  @override
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
  Geolocator _geolocator;
  String _address;
  MapController _mapController;
  LatLng point;
  Marker pointMark;

  @override
void initState() {
      super.initState();
      _mapController = MapController();
      _address = this.widget.address;
      setMarker(_address);
    }


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.title),
        backgroundColor: Colors.transparent,
      ),
      body:FlutterMap(
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
        MarkerLayerOptions(markers: [pointMark]),
        
      ],
    )
    );
  }

  Future<void> setMarker(String loc) async {
    List<gc.Location> p = await gc.locationFromAddress(loc);
    if (p.isNotEmpty) {
      pointMark = new Marker(point: new LatLng(p[0].latitude, p[0].longitude));
    }
}
}
