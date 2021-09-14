import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/utility/constants.dart';
import 'package:untitled/utility/widgets.dart';
import 'package:editable/editable.dart';
import 'package:intl/intl.dart';

class SubmitReadings extends StatefulWidget {
  const SubmitReadings({Key? key}) : super(key: key);

  @override
  _SubmitReadingsState createState() => _SubmitReadingsState();
}

class _SubmitReadingsState extends State<SubmitReadings> {
  final formKey = GlobalKey<FormState>();
  final _editableKey = GlobalKey<EditableState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedInitialFromTime = TimeOfDay.now();
  TimeOfDay selectedInitialToTime = TimeOfDay.now();

  String _emergencyContact = "";
  String _address = "";
  String _dateOfContact = "Tap to select date";
  String _durationFrom = "Select Time1";
  String _durationTo = "Select Time2";

  String _location = "Tap to select Location";
  String _latLangLocation = "";

  LatLng cameraPosition =  LatLng(7.1930961, 80.2648257);
  late GoogleMapController _googleMapController;

  String _category = 'Home Quarantine Patient';
  var categoryList = [
    'Home Quarantine Patient',
    'Home Quarantine Close Contact'
  ];

  String _spo2 = '95% - 100%';
  var spO2List = [
    '95% - 100%',
    '91% < 94%',
    '81% < 90%',
    '80% - 85%',
    'Below 80%'
  ];

  String _temperature = '36.5°C - 36.0°C';
  var temperatureList = [
    'Above 38.0°C',
    '38.0°C - 37.5°C',
    '37.0°C - 36.5°C',
    '36.5°C - 36.0°C',
    '36.0°C - 35.5°C',
    '35.0°C - 34.5°C'
  ];

  List rows = [
    {
      "date": '2021/02/01',
      "from": '06.00',
      "to": '06.15',
      "location": 'Bar Flutter'
    },
  ];

  List cols = [
    {"title": 'Date', 'widthFactor': 0.2, 'key': 'date'},
    {"title": 'From', 'widthFactor': 0.2, 'key': 'from'},
    {"title": 'To', 'widthFactor': 0.2, 'key': 'to'},
    {"title": 'Location', 'widthFactor': 0.2, 'key': 'location'},
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        _dateOfContact = new DateFormat.yMMMMd("en_US").format(selectedDate);
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
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());

    if (pickedTime != null)
      setState(() {
        _durationTo = pickedTime.format(context);
      });
  }

  void _addNewRow() {
    setState(() {
      _editableKey.currentState!.createRow();
    });
  }

  void _printEditedRows() {
    List editedRows = _editableKey.currentState!.editedRows;
    print(editedRows);
  }

  @override
  Widget build(BuildContext context) {
    var doLogin = () {
      final form = formKey.currentState;

      if (form != null && form.validate()) {
        form.save();

        final Map<String, dynamic> requestBody = {
          "quarantineCenterContact": _emergencyContact,
          "quarantineCenter": _address,
          "spo2Level": _spo2,
          "bodyTemp": _temperature
        };

        http
            .post(
          Uri.parse(Constants.BASEURL),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        )
            .then((response) {
          if (response.statusCode == 200) {
            _showToast(context, 'Login Success!');
            Navigator.pushReplacementNamed(context, '/secure/dashboard');
          } else {
            _showToast(context, 'Bad Credentials!');
          }
        });
      } else {
        _showToast(context, 'Please Resubmit Registration Details!');
      }
    };

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Text("Category"),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _category,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 20,
                      elevation: 16,
                      items: categoryList.map((String categorySelected) {
                        return DropdownMenuItem(
                            value: categorySelected,
                            child: Text(
                              categorySelected,
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _category = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Quarantine Center Address"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value!.isEmpty ? "Please Enter Address of Center" : null,
                  onSaved: (value) => _address = value!,
                  decoration: buildInputDecoration(
                      "Please Enter Address!", Icons.location_on),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Emergency Contact Number of the Center"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value!.isEmpty ? "Emergency Contact Number" : null,
                  onSaved: (value) => _emergencyContact = value!,
                  decoration: buildInputDecoration(
                      "Enter Emergency Contact!", Icons.phone),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Contact Tracing"),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text("Date: "),
                      Text(_dateOfContact),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed:(){
                          _selectDate(context);
                        },
                      )
                    ],
                  ),
                ),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text("From: "),
                        Text(_durationFrom),
                        IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed:(){
                            _selectFromTime(context);
                          },
                        ),
                        Text(" To: "),
                        Text(_durationTo),
                        IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed:(){
                            _selectToTime(context);
                          },
                        )
                      ],
                    )
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text("Location: "),
                        Text(_location),
                        IconButton(
                          icon: Icon(Icons.place_rounded),
                          onPressed:(){
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: cameraPosition,
                                      zoom: 11.0,
                                    ),
                                    mapType: MapType.normal,
                                    myLocationEnabled: true,
                                    onMapCreated: (controller){
                                      setState(() {
                                        _googleMapController = controller;
                                        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: cameraPosition, zoom: 11.0)));
                                        new Marker(
                                          icon: BitmapDescriptor.defaultMarker,
                                          markerId: MarkerId("currentPosition"),
                                          position: cameraPosition,
                                          infoWindow: InfoWindow(title: "userMarker", snippet: '*'),
                                        );
                                      });
                                    },
                                    onTap: (coordinate){
                                      _googleMapController.animateCamera(CameraUpdate.newLatLng(coordinate));
                                    },
                                  );
                                });
                          },
                        ),
                      ],
                    )
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 600,
                  child: Editable(
                      key: _editableKey,
                      columns: cols,
                      rows: rows,
                      showCreateButton: true,
                      zebraStripe: true,
                      tdStyle: TextStyle(fontSize: 15),
                      showSaveIcon: false,
                      borderColor: Colors.grey.shade300,
                      onRowSaved: (value) {
                        print(value);
                        },
                      onSubmitted: (value) {
                        print(value);
                        },
                      tdAlignment: TextAlign.left
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: Text("Current Readings"),
                ),
                SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SpO2 Level"),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _spo2,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                elevation: 16,
                                items: spO2List.map((String categorySelected) {
                                  return DropdownMenuItem(
                                      value: categorySelected,
                                      child: Text(
                                        categorySelected,
                                      ));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _spo2 = newValue!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Body Temperature"),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _temperature,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                elevation: 16,
                                items: temperatureList.map((String categorySelected) {
                                  return DropdownMenuItem(
                                      value: categorySelected,
                                      child: Text(
                                        categorySelected,
                                      ));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _temperature = newValue!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    ]),
                SizedBox(
                  height: 20.0,
                ),
                longButtons("Submit", doLogin),
              ],
            ),
          ),
        ),
      ),
    );
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
}
