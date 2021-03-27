import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'globals.dart' as globals;



class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  List<Marker> myMarker = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
        CameraPosition(target: LatLng(35.6892, 51.3890), zoom: 14.0),
        markers: Set.from(myMarker),
        onTap: _handleTap,
      )
    );
  }

  _handleTap(LatLng tappedPoint) {

    setState(() {
      globals.latitude = tappedPoint.latitude;
      globals.longitude = tappedPoint.longitude;
      myMarker = [];
      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
        )
      );
      print('MAAAAAAAAARKER${myMarker.first}');
    });
    Navigator.pop(context); // return location;
  }
}
