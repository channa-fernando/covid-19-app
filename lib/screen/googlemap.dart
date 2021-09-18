import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:untitled/dto/CircleResponseDTO.dart';
import 'package:untitled/dto/LatLangDTO.dart';
import 'package:untitled/utility/constants.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController _googleMapController;
  LatLng currentPosition = LatLng(7.1930961, 80.2648257);

  List<Marker> myMarker = <Marker>[];
  List<Circle> myCircles = <Circle>[];

  String _dateOfContact = "Date  ";
  String _durationFrom = "From  ";
  String _durationTo = "To   ";
  late BitmapDescriptor icon;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedInitialFromTime = TimeOfDay.now();
  TimeOfDay selectedInitialToTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getIcons();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 441,
              child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentPosition,
                    zoom: 14.0,
                  ),
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  markers: Set.from(myMarker),
                  circles: Set.from(myCircles),
                  onMapCreated: (controller) {
                    setState(() {
                      _googleMapController = controller;
                      _googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: currentPosition, zoom: 11.0)));
                      myMarker.add(new Marker(
                        icon: BitmapDescriptor.defaultMarker,
                        markerId: MarkerId("currentPosition"),
                        position: currentPosition,
                        infoWindow:
                            InfoWindow(title: "userMarker", snippet: '*'),
                      ));
                    });
                  },
                  onTap: (coordinate) {
                    setState(() {
                      // _googleMapController.animateCamera(CameraUpdate.newLatLng(coordinate));
                      print(coordinate);
                      myMarker = [];
                      myMarker.add(Marker(
                        markerId: MarkerId(coordinate.toString()),
                        position: coordinate,
                      ));

                    });
                  }),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Find Contacts",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                      ),
                      IconButton(onPressed: _getMarkers, icon: Icon(Icons.search_outlined), iconSize: 35,),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(3.0)
                          ),
                          child:Row(
                              children: <Widget>[
                                Text(_dateOfContact),
                                IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              ]
                          )
                        ),
                        Container(
                            margin: const EdgeInsets.all(5.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(3.0)
                            ),
                            child:Row(
                                children: <Widget>[
                                  Text(_durationFrom),
                                  IconButton(
                                    icon: Icon(Icons.access_time),
                                    onPressed: () {
                                      _selectFromTime(context);
                                    },
                                  ),
                                  Text(_durationTo),
                                  IconButton(
                                    icon: Icon(Icons.access_time),
                                    onPressed: () {
                                      _selectToTime(context);
                                    },
                                  )
                                ]
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[

                      ],
                    ),
                  ),
                ],
              )

            ),
          ],
        ),
      ),
    );
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Location: " +
        position.longitude.toString() +
        " , " +
        position.longitude.toString());
    print(position);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2),
        "assets/pngs/marker.png");
    setState(() {
      this.icon = icon;
    });
  }

  void _getMarkers() async {
    final Map<String, dynamic> requestBody = {
      "date": _dateOfContact,
      "from": _durationFrom,
      "to": _durationTo
    };
    print(requestBody);

    var response = await http.post(
      Uri.parse(Constants.BASEURL + "/data" + "/getcircles"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      CircleResponseDTO circleResponseDTO = CircleResponseDTO.fromJson(jsonDecode(response.body));
      List<LatLang> positions = circleResponseDTO.latLangList;
      myCircles = [];
      myMarker = [];
      for(var item in positions){
        setState(() {
          myCircles.add(Circle(
            circleId: CircleId(DateTime.now().toString()),
            center: LatLng(double.parse(item.longitude), double.parse(item.latitude)),
            radius:30,
            fillColor:Colors.redAccent,
            strokeColor: Colors.black12,
            strokeWidth: 3,

          ));
          myMarker.add(Marker(
            markerId: MarkerId(DateTime.now().toString()),
            position: LatLng(double.parse(item.longitude), double.parse(item.latitude)),
            infoWindow: InfoWindow(title: "Risk Area", snippet: 'Covid Contact Area',),

          ));
        });
        print("Location From API:");
        print(double.parse(item.longitude));
        print(double.parse(item.latitude));
      }
    } else {
      _showToast(context, 'Data Loading Failed!');
    }
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        _dateOfContact = new DateFormat.yMd("en_US").format(selectedDate);
      });
  }

  Future<void> _selectFromTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 12-Hour format
                  alwaysUse24HourFormat: false),
              // If you want 24-Hour format, just change alwaysUse24HourFormat to true
              child: child!);
        });

    if (pickedTime != null)
      setState(() {
        _durationFrom = pickedTime.format(context);
      });
  }

  Future<void> _selectToTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedTime != null)
      setState(() {
        _durationTo = pickedTime.format(context);
      });
  }
  _serchMarkers(){}
}
