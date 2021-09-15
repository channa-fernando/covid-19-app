import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/screen/submitreadings.dart';

class AddEntryDialog extends StatefulWidget {
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {
  LatLng _traceLocation = LatLng(7.1930961, 80.2648257);
  LatLng cameraPosition = LatLng(7.1930961, 80.2648257);

  late GoogleMapController _googleMapController;
  List<Marker> myMarker = [];
  String _location = "Select Location";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New Location'),
        actions: [
          new FlatButton(
              onPressed: () {
                Navigator
                    .of(context)
                    .pop(new SubmitReadings(locationSelectedFromMap: _location,));
              },
              child: new Text('SAVE',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead!
                      .copyWith(color: Colors.white))),
        ],
      ),
      body:Container(
        height: 300,
        child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: cameraPosition,
              zoom: 14.0,
            ),
            markers: Set.from(myMarker),
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: (controller) {
              setState(() {
                _googleMapController = controller;
                _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: cameraPosition, zoom: 14.0)));
              });
            },
            onTap: (coordinate) {
              setState(() {
                // _googleMapController.animateCamera(CameraUpdate.newLatLng(coordinate));
                _traceLocation = coordinate;
                _location = coordinate.longitude.toString() + ",\n"+ coordinate.latitude.toString() ;
                myMarker = [];
                myMarker.add(Marker(
                  markerId: MarkerId(coordinate.toString()),
                  position: coordinate,
                ));
                print(_location);
              });
            }),
      ),
    );
  }
}