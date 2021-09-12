import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}



class _MapViewState extends State<MapView> {

  late GoogleMapController _googleMapController;
  LatLng currentPosition =  LatLng(7.1930961, 80.2648257);

  @override
  void initState () {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentPosition,
          zoom: 11.0,

        ),
        mapType: MapType.normal,
        myLocationEnabled: true,
        onMapCreated: (controller){
         setState(() {
           _googleMapController = controller;
           _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentPosition,zoom: 11.0)));
           new Marker(
             icon: BitmapDescriptor.defaultMarker,
             markerId: MarkerId("currentPosition"),
             position: currentPosition,
             infoWindow: InfoWindow(title: "userMarker", snippet: '*'),
           );
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

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Location: " + position.longitude.toString() + " , " +  position.longitude.toString());
    print(position);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }
}
