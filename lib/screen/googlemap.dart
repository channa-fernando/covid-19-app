import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  final CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(7.1930961, 80.2648257));
  late GoogleMapController _googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller){
         setState(() {
           _googleMapController = controller;
         });
        },
        onTap: (coordinate){
          _googleMapController.animateCamera(CameraUpdate.newLatLng(coordinate));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.zoom_out),
      ),
    );
  }
}
