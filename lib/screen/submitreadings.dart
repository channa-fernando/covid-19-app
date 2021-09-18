import 'dart:convert';

import 'package:editable/editable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:untitled/screen/mapPopup.dart';
import 'package:untitled/utility/constants.dart';
import 'package:untitled/utility/widgets.dart';

class SubmitReadings extends StatefulWidget {
  final String locationSelectedFromMap;
  const SubmitReadings({ Key? key, required this.locationSelectedFromMap }) : super(key: key);

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
  String _dateOfContact = "Select Date";
  String _durationFrom = "Select Time";
  String _durationTo = "Select Time";
  String _location = "Select Location";
  int _contactTracingTableSize = 0;
  LatLng _traceLocation = LatLng(7.1930961, 80.2648257);
  LatLng cameraPosition = LatLng(7.1930961, 80.2648257);

  late GoogleMapController _googleMapController;
  List<Marker> myMarker = [];
  var contactDataMapArray = <Map>[];
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

  List<DataRow> dataRows = [
    DataRow(
      cells: [
        DataCell(Text("Select a Date!", textAlign: TextAlign.start,), placeholder: true,),
        DataCell(Text("Select a Duration!", textAlign: TextAlign.start,), placeholder: true),
        DataCell(Text("Select a Location!", textAlign: TextAlign.start,), placeholder: true),
      ],
    )
  ];


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


  @override
  Widget build(BuildContext context) {
    var doSubmit = () async {
      final form = formKey.currentState;

      if (form != null && form.validate()) {
        form.save();

        final Map<String, dynamic> requestBody = {
          "quarantineCenterContact": _emergencyContact,
          "quarantineCenter": _address,
          "spo2Level": _spo2,
          "bodyTemp": _temperature,
          "tracing": contactDataMapArray
        };
        var response = await http.post(
          Uri.parse(Constants.BASEURL +"/data"+ "/submitreadings" ),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        );

        print(response.body);
        if (response.statusCode == 200) {
          _showToast(context, 'Data Submitted Successfully!');

        } else {
          _showToast(context, 'Bad Data!');
        }
      }
      else {
        _showToast(context, 'Please Resubmit Registration Details!');
      }
    };

    return SafeArea(child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 65,
                  alignment: Alignment(-0.75, 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(onPressed: (){}, icon: Icon(Icons.menu, size: 25,color: Colors.white,)),
                      SizedBox(
                        width: 12.0,
                      ),
                      Text("Report Incident",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 25.0),),
                    ],
                  )

              ),
              Container(
                color: Colors.blue,
                child: Container(
                    width: double.infinity,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: new BorderRadius.vertical(
                        top: Radius.elliptical(150, 30),
                      ),
                    )),
              ),]
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
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
                  padding: EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text("Date: "),
                            Text(_dateOfContact),
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
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
                            onPressed: () {
                              _selectFromTime(context);
                            },
                          ),
                          Text(" To: "),
                          Text(_durationTo),
                          IconButton(
                            icon: Icon(Icons.access_time),
                            onPressed: () {
                              _selectToTime(context);
                            },
                          )
                        ],
                      )),
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
                            onPressed: _openAddEntryDialog,
                          ),
                        ],
                      )),
                      Container(
                        padding: EdgeInsets.all(1.0),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5.0),
                        //     border: Border.all()),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.add_circle_rounded,
                                color: Colors.blue,
                                size: 35,
                              ),
                              onPressed: _addToTable,
                            ),
                            Text(
                              "Add to Table",style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  color: Colors.white,
                  child: DataTable(
                    sortAscending: true,
                    sortColumnIndex: 0,
                    columns: [
                      DataColumn(
                        label: Text("Date", textAlign: TextAlign.start),
                      ),
                      DataColumn(
                          label: Text("Duration", textAlign: TextAlign.start)),
                      DataColumn(
                          label: Text("Location", textAlign: TextAlign.start)),
                    ],
                    rows: dataRows,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                items: temperatureList
                                    .map((String categorySelected) {
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
                longButtons("Submit", doSubmit),
              ],
            ),
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

  void _addToTable(){
    setState(() {
      print("Start");
      print(_dateOfContact);
      print(_durationFrom);
      print(_durationTo);
      print(_traceLocation.longitude);
      print(_traceLocation.latitude);
      print("End");

      if (_dateOfContact.contains("Select")) {
        _showToast(context, "Please Select a Date");
      }
      if (_durationFrom.contains("Select") || _durationTo.contains("Select")) {
        _showToast(context, "Please Select a Duration");
      }
      if (_location.contains("Select")) {
        _showToast(context, "Please Select a Location");
      }
      final Map<String, String> contactMap = {
        "latLang": _location,
        "date": _dateOfContact,
        "from":_durationFrom,
        "to":_durationTo
      };
      contactDataMapArray.add(contactMap);
      print(contactDataMapArray);
      if (_contactTracingTableSize == 0) {
        dataRows = [
          DataRow(
            cells: [
              DataCell(Container(width: 80, child: Text(_dateOfContact, textAlign: TextAlign.left,),),),
              DataCell(Container(width: 70, child: Text(_durationFrom + " - " + _durationTo, textAlign: TextAlign.left,),),),
              DataCell(Container(width: 150, child: Text(_location, textAlign: TextAlign.start,),),)
            ],
          )
        ];
      } else {
        DataRow newDataRow = DataRow(
            cells: [
              DataCell(Container(width: 80, child: Text(_dateOfContact, textAlign: TextAlign.left,),),),
              DataCell(Container(width: 70, child: Text(_durationFrom + " - " + _durationTo, textAlign: TextAlign.left,),),),
              DataCell(Container(width: 150, child: Text(_location, textAlign: TextAlign.start,),),)
            ]);
        dataRows.add(newDataRow);
      }
      _contactTracingTableSize = 1;
    });
  }

  Future _openAddEntryDialog() async {
    SubmitReadings? save = await Navigator.of(context).push(new MaterialPageRoute<SubmitReadings>(
        builder: (BuildContext context) {
          return new AddEntryDialog();
        },
        fullscreenDialog: true
    ));
    if (save != null) {
      setState(() {
        _location = save.locationSelectedFromMap;
      });
    }
  }
  void _searchNavigate() {}
}
