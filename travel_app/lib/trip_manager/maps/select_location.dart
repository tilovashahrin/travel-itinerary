import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoding/geocoding.dart' as gc;

class ShowLocation extends StatefulWidget {
  ShowLocation({Key key}) : super(key: key);

  @override
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
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
        //title: Text(widget.title),
        backgroundColor: Colors.transparent,
      ),
      body: Column(children: [
        TextField(onSubmitted: (text) {
          searchForLocation(text);
        }),
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
            MarkerLayerOptions(markers: []),
          ],
        ),
          height: 0.8 * MediaQuery.of(context).size.height,

        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop([userSearch, point]);
        },
        child: Icon(Icons.save),
      ),
    );
  }

  searchForLocation(String search) async {
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
        //DO SOMETHING to tell user search invalid
      }
    }
  }
}
