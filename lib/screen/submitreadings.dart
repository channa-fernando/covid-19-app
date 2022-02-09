import 'dart:convert';

import 'package:editable/editable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String token = "";

  String _emergencyContact = "";
  String _address = "";
  String _dateOfContact = "Select Date";
  String _durationFrom = "Select Time";
  String _durationTo = "Select Time";
  String _location = "Select Location";
  int _contactTracingTableSize = 0;
  LatLng _traceLocation = LatLng(7.1930961, 80.2648257);
  LatLng cameraPosition = LatLng(7.1930961, 80.2648257);
  String _nameOfPositiveCase = "";
  late GoogleMapController _googleMapController;
  List<Marker> myMarker = [];
  var contactDataMapArray = <Map>[];
  String _category = 'Home Quarantine Patient';
  var categoryList = [
    'Home Quarantine Patient',
    'Home Quarantine Close Contact',
    'Other'
  ];
  String _option1 = 'NotSure';
  String _option2 = 'NotSure';
  String _option3 = 'NotSure';
  String _option4 = 'NotSure';
  String _option5 = 'NotSure';
  String _option6 = 'NotSure';
  String _option7 = 'NotSure';
  String _option8 = 'NotSure';
  String _option9 = 'NotSure';
  String _option10 = 'NotSure';
  String _option11 = 'NotSure';
  String _option12 = 'NotSure';
  String _option13 = 'NotSure';
  String _option14 = 'NotSure';

  var optionList = [
    'Yes','No', 'NotSure'
  ];
  var questionAnswersArray = [];
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
  String _areYouVaccinated = 'One Dose';
  var _areYouVaccinatedList = ['One Dose', 'Two Doses', 'Booster', 'No'];

  String _areYouLongTermTreat = 'Yes';
  var _areYouLongTermTreatList = ['Yes', 'No'];

  String _daysOfContact = '14';
  var _daysOfContactList = ['14','13','12','11','10','9','8','7','6','5','4','3','2','1','0'];

  String _daysOfLastContact = '1';
  var _daysOfLastContactList = ['31','30','29','28','27','26','25','24','23','22','21','20','19','18','17','16','15','14','13','12','11','10','9','8','7','6','5','4','3','2','1','0'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        _dateOfContact = new DateFormat.yMd("en_US").format(picked);
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
        await showTimePicker(context: context, initialTime: TimeOfDay.now(),
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
        _durationTo = pickedTime.format(context);
      });
  }


  @override
  Widget build(BuildContext context) {
    var doSubmit = () async {
      final form = formKey.currentState;
      if (form != null && form.validate()) {
        form.save();

        final prefs = await SharedPreferences.getInstance();
        token = prefs.getString('token')!;
        _getAnswers();
        final Map<String, dynamic> requestBody = {
          "quarantineCenterContact": _emergencyContact,
          "quarantineCenter": _address,
          "spo2Level": _spo2,
          "bodyTemp": _temperature,
          "nameOfPositiveCase": _nameOfPositiveCase,
          "areYouVaccinated": _areYouVaccinated,
          "areYouLongTermTreat": _areYouLongTermTreat,
          "daysOfContact" : _daysOfContact,
          "daysOfLastContact" :_daysOfLastContact,
          "answersArray": questionAnswersArray,
          "tracing": contactDataMapArray
        };
        var response = await http.post(
          Uri.parse(Constants.BASEURL +"/data"+ "/submitreadings" ),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': token
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
                Text("Are you Vaccinated?"),
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
                      value: _areYouVaccinated,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 20,
                      elevation: 16,
                      items: _areYouVaccinatedList.map((String categorySelected) {
                        return DropdownMenuItem(
                            value: categorySelected,
                            child: Text(
                              categorySelected,
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _areYouVaccinated = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Are you on any long-term Treatment?"),
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
                      value: _areYouLongTermTreat,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 20,
                      elevation: 16,
                      items: _areYouLongTermTreatList.map((String categorySelected) {
                        return DropdownMenuItem(
                            value: categorySelected,
                            child: Text(
                              categorySelected,
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _areYouLongTermTreat = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Quarantine Center/Home Address"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value!.isEmpty ? "Please Enter Address of Center/Home" : null,
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
                Text("Details of index case"),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 180,
                              child:Text("Name of the Positive Case"),
                            ),
                            Container(
                              width: 150,
                              child: TextFormField(
                                autofocus: false,
                                onSaved: (value) => _nameOfPositiveCase = value!,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                                    border: OutlineInputBorder()),

                              ),
                            )
                                                     ],
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 270,
                              child:Text("Days of contact (during infections period of positive case)"),
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
                                  value: _daysOfContact,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 20,
                                  elevation: 16,
                                  items: _daysOfContactList.map((String categorySelected) {
                                    return DropdownMenuItem(
                                        value: categorySelected,
                                        child: Text(
                                          categorySelected,
                                        ));
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _daysOfContact = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 270,
                              child:Text("Date of last contact (during infections period of positive case)"),
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
                                  value: _daysOfLastContact,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 20,
                                  elevation: 16,
                                  items: _daysOfLastContactList.map((String categorySelected) {
                                    return DropdownMenuItem(
                                        value: categorySelected,
                                        child: Text(
                                          categorySelected,
                                        ));
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _daysOfLastContact = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20.0,
                ),
                Text("Nature of Contact"),
                SizedBox(
                  height: 5.0,
                ),
                DefaultTabController(
                  length: 3,
                  child: SizedBox(
                    height: 380.0,
                    child: Column(
                      children: <Widget>[
                        TabBar(
                          tabs: <Widget>[
                            Tab(
                              child: Text("Activity", style: TextStyle(color: Colors.black)),

                            ),
                            Tab(
                              child: Text("Work Place", style: TextStyle(color: Colors.black)),
                            ),
                            Tab(
                              child: Text("Gathering", style: TextStyle(color: Colors.black)),
                            )
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(10.0),
                                child: DataTable(
                                  sortAscending: true,
                                  sortColumnIndex: 0,
                                  headingRowHeight: 0,
                                  columnSpacing: 20.0,
                                  columns: [
                                    DataColumn(
                                      label: Text("Date", textAlign: TextAlign.start),
                                    ),
                                    DataColumn(
                                      label: Text("Date", textAlign: TextAlign.start),
                                    )
                                  ],
                                  rows: [
                                    DataRow(cells: [
                                      DataCell(Container(child: Text('Was your colleague wearing mask at all times during the Interaction?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option1,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                                value: categorySelected,
                                                child: Text(
                                                  categorySelected,
                                                    style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option1= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Were you wearing a mask during all interactions?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option2,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option2= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Did you share a meal or eat in the same table at least once during infectious period*?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option3,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option3= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container(child: Text('Did you share bottle/glass/tea cup, personal items (pen, purse, keys, books, etc..) at least once during infectious period*')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option4,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option4= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Did you share same transport during infectious period*')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option5,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option5= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Did you share bed room during infectious period*')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option6,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option6= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(10.0),
                                child: DataTable(
                                  sortAscending: true,
                                  sortColumnIndex: 0,
                                  headingRowHeight: 0,
                                  columns: [
                                    DataColumn(
                                      label: Text("Date", textAlign: TextAlign.start),
                                    ),
                                    DataColumn(
                                      label: Text("Date", textAlign: TextAlign.start),
                                    )
                                  ],
                                  rows: [
                                    DataRow(cells: [
                                      DataCell(Container(child: Text('Do you work in same room during infectious period*?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option7,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option7= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Shared work place air conditioned?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option8,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option8= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Work place poorly ventilated or crowded?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option9,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option9= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(10.0),
                                child: DataTable(
                                  sortAscending: true,
                                  sortColumnIndex: 0,
                                  headingRowHeight: 0,
                                  columns: [
                                    DataColumn(
                                      label: Text("Date", textAlign: TextAlign.start),
                                    ),
                                    DataColumn(
                                      label: Text("Date", textAlign: TextAlign.start),
                                    )
                                  ],
                                  rows: [
                                    DataRow(cells: [
                                      DataCell(Container(child: Text('Were you in a gathering (Ex - Meeting, Class, Discussion, Practical) with the index case during the infectious period*?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option10,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option10= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Was the room where the gathering was held filled to more than 50% of capacity?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option11,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option11= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Was the room where gathering was held air conditioned?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option12,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option12= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container(child: Text('Was the room where the gathering was held poorly ventilated')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option13,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option13= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Container( child: Text('Was the gathering held for more than 15 min?')),),
                                      DataCell(Container(child:DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _option14,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 10,
                                          elevation: 16,
                                          items: optionList.map((String categorySelected) {
                                            return DropdownMenuItem(
                                              value: categorySelected,
                                              child: Text(
                                                categorySelected,
                                                style: TextStyle(fontSize:15), textAlign: TextAlign.center,),);
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _option14= newValue!;
                                            });
                                          },
                                        ),
                                      )),),
                                    ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("*Infectious period – Two day before sample collection for asymptomatic patients, three days before symptom onset for symptomatic patients.",
                        style: TextStyle(fontWeight: FontWeight.w400)
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Please describe your interactions with the colleague confirmed to have covid 19 in your own words."),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child:
                  TextField(
                    maxLines: 8,
                    decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                  ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
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

  List _getAnswers(){
    questionAnswersArray.add(_option1);
    questionAnswersArray.add(_option2);
    questionAnswersArray.add(_option3);
    questionAnswersArray.add(_option4);
    questionAnswersArray.add(_option5);
    questionAnswersArray.add(_option6);
    questionAnswersArray.add(_option7);
    questionAnswersArray.add(_option8);
    questionAnswersArray.add(_option9);
    questionAnswersArray.add(_option10);
    questionAnswersArray.add(_option11);
    questionAnswersArray.add(_option12);
    questionAnswersArray.add(_option13);
    questionAnswersArray.add(_option14);
    return questionAnswersArray;
  }
}
