import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapScreen extends StatefulWidget {

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {

  static double latitude;
  static double longitude;

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
      latitude = tappedPoint.latitude;
      longitude = tappedPoint.longitude;
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
