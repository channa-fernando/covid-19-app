import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  final CameraPosition initialCameraPosition = CameraPosition(target: LatLng(7.1930961, 80.2648257));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  mapType: MapType.normal,
                ),
              )
            ],
          ),
    ));
  }
}
