import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';



class MapScreen extends StatefulWidget {

  final Contact contact;
  MapScreen(this.contact);

  @override
  MapScreenState createState() => MapScreenState(contact);
}

class MapScreenState extends State<MapScreen> {

  List<Marker> myMarker = [];
  final Contact contact;

  MapScreenState(this.contact);

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
      contact.latitude = tappedPoint.latitude;
      contact.longitude = tappedPoint.longitude;
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
