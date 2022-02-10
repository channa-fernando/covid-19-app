import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/dto/covidUpdate.dart';
import 'package:untitled/utility/constants.dart';
import 'package:untitled/utility/widgets.dart';
import 'package:untitled/dto/patientReportDTO.dart';

class CovidDetails extends StatefulWidget {
  const CovidDetails({Key? key}) : super(key: key);

  @override
  _CovidDetailsState createState() => _CovidDetailsState();
}

class _CovidDetailsState extends State<CovidDetails> {
  int _current = 0;
  List imgList = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
    'assets/images/banner4.jpg',
    'assets/images/banner5.jpg'
  ];

  List gifList = ['assets/pngs/icon1.gif', 'assets/pngs/icon2.gif'];

  late String _date = "";
  late String _localNewCases = "";
  late String _localTotalCases = "";
  late String _localNewDeaths = "";
  late String _localTotalDeaths = "";
  late int _counter = 0;
  String _spo2 = '95% - 100%';
  var spO2List = [
    '95% - 100%',
    '91% < 94%',
    '81% < 90%',
    '80% - 85%',
    'Below 80%'
  ];
  final List<String> _names = [
    'Liam', 'Noah', 'Oliver', 'William', 'Elijah',
    'James', 'Benjamin', 'Lucas', 'Mason', 'Ethan', 'Alexander'
  ];
  int _patientId = 0;
  var _patientsNames = <String>["1:Channa"];

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

  String _temperature = '36.5°C - 36.0°C';
  var temperatureList = [
    'Above 38.0°C',
    '38.0°C - 37.5°C',
    '37.0°C - 36.5°C',
    '36.5°C - 36.0°C',
    '36.0°C - 35.5°C',
    '35.0°C - 34.5°C'
  ];

  var doSubmit = (){};

  late String _commentText = "";

  @override
  void initState() {
    super.initState();
    getCovidLiveUpdate();
    getPatientList();
  }

  @override
  Widget build(BuildContext context) {
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
                      Text("Protect Yourself",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 23.0),),
                      SizedBox(
                        width: 100.0,
                      ),
                      _bellIconList()
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 15 / 13,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  enableInfiniteScroll: true,
                  autoPlayInterval: Duration(seconds: 10),
                  autoPlayAnimationDuration: Duration(milliseconds: 2000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: callBackFunction,
                ),
                items: imgList.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: 300.0,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(color: Colors.green),
                        child: Image.asset(imgUrl, fit: BoxFit.fill),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Recent Numbers",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    width: 35.0,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_rounded,
                      color: Colors.blue,
                      size: 35,
                    ),
                    onPressed: _showReadingsPopup,
                  ),
                  Text(
                    "Report Readings",style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 135,
                      height: 55,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                            width: 1.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.rectangle),
                            child: Image.asset(gifList[0], fit: BoxFit.fill),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "New Cases",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(_localNewCases,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 135,
                      height: 55,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                            width: 1.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.rectangle),
                            child: Image.asset(gifList[1], fit: BoxFit.fill),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "New Deaths",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(_localNewDeaths,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey)),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
              //New
              SizedBox(
                height: 15.0,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 135,
                      height: 55,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                            width: 1.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.rectangle),
                            child: Image.asset(gifList[0], fit: BoxFit.fill),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Total Cases",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(_localTotalCases,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 135,
                      height: 55,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                            width: 1.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.rectangle),
                            child: Image.asset(gifList[1], fit: BoxFit.fill),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Total Deaths",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(_localTotalDeaths,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey)),
                            ],
                          )
                        ],
                      ),
                  )
                ]),
            //New
          ],
        ),
      ),),);
  }

  void getCovidLiveUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userId'));
    print(prefs.getString('token'));
    print(prefs.getString('address'));
    print(prefs.getString('userName'));

    var response = await http.get(Uri.parse(Constants.SL_HEALTH_COVID_ENDPOINT),
        headers: <String, String>{
          'Content-Type': 'application/json',
        });

    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      CovidUpdate covidUpdate = CovidUpdate.fromJson(jsonDecode(response.body));
      _date = covidUpdate.date;
      _localNewCases = covidUpdate.localNewCases;
      _localTotalCases = covidUpdate.localTotalCases;
      _localNewDeaths = covidUpdate.localNewDeaths;
      _localTotalDeaths = covidUpdate.localTotalDeaths;
    } else {
      _showToast(context, 'Data Loading Failed!');
    }
  }

  void getPatientList() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    print(Constants.BASEURL + "/monitoring/patientList" + userId.toString());
    var response = await http.get(Uri.parse(Constants.BASEURL + "/monitoring/notificationList/" + userId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
        });

    print(response.body);
    if (response.statusCode == 200) {
      print("Patients List: " + response.body);
      _setPatientList(response.body);
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

  callBackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      _current = index;
    });
  }

  void _showReadingsPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Submit Readings", textAlign: TextAlign.center,),
            content: Container(
              height: 200,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("SpO2 Level"),
                        SizedBox(
                          height: 15.0,
                          width: 25.0,
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
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Temperature"),
                          SizedBox(
                            height: 15.0,
                            width: 15.0,
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
                        ]
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    longButtons("Submit", doSubmit),
                  ]
              ),
            ),
          );
        }
    );
  }
  void _setBellCounter(int count) {
    setState(() {
      _counter= count;
    });
  }

  void _setPatientList(String commaSeperatedPatients) {
    setState(() {
      List<String> names = commaSeperatedPatients.split(',');
      names.removeAt(names.length - 1);
      _patientsNames = names;

      print("_patientsNames: " + _patientsNames.toString());
      _setBellCounter(_patientsNames.length);
    });
  }

  // set up the AlertDialog
  AlertDialog alert(String title, List<String> basicQuestions, List<String> answers, String dateOfSubmission) => AlertDialog(
    title: Text("Risk Assessment Report Response"),
    content: Container(
        height: 1000,
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Patient Name: Mr: ' + title),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                  Text('Date of Submission: '),
                  Text(dateOfSubmission, style: const TextStyle(fontWeight: FontWeight.bold))]
              ),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Text("Are you Vaccinated? "),
                Text(basicQuestions[0], style: const TextStyle(fontWeight: FontWeight.bold))]
              ),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Text("On long-term Treatment? "),
                Text(basicQuestions[1], style: const TextStyle(fontWeight: FontWeight.bold))]
              ),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Text("Name of the Positive Case? "),
                Text(basicQuestions[2], style: const TextStyle(fontWeight: FontWeight.bold))]
              ),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Text("Days of contact? "),
                Text(basicQuestions[3], style: const TextStyle(fontWeight: FontWeight.bold))]
              ),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Text("Date of last contact? "),
                Text(basicQuestions[4], style: const TextStyle(fontWeight: FontWeight.bold))]
              ),
              SizedBox(
                height: 10,
              ),
              DefaultTabController(
                length: 3,
                child: SizedBox(
                  height: 400.0,
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
                              margin: const EdgeInsets.all(0.0),
                              child: DataTable(
                                sortAscending: true,
                                sortColumnIndex: 0,
                                headingRowHeight: 0,
                                columnSpacing: 2.0,
                                dataRowHeight: 50.0,
                                columns: [
                                  DataColumn(
                                    label: Text("Question", textAlign: TextAlign.start),
                                  ),
                                  DataColumn(
                                    label: Text("Answer", textAlign: TextAlign.start),
                                  )
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Container(child: Text('Was your colleague wearing mask at all times during the Interaction?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[0], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Were you wearing a mask during all interactions?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[1], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Did you share a meal or eat in the same table at least once during infectious period*?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[2], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container(child: Text('Did you share bottle/glass/tea cup, personal items (pen, purse, keys, books, etc..) at least once during infectious period*', style: TextStyle(fontSize: 11.0),),),),
                                    DataCell(Container(child: Text(answers[3], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Did you share same transport during infectious period*', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[4], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Did you share bed room during infectious period*', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[5], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(0.0),
                              child: DataTable(
                                sortAscending: true,
                                sortColumnIndex: 0,
                                headingRowHeight: 0,
                                columnSpacing: 2,
                                dataRowHeight: 50,
                                columns: [
                                  DataColumn(
                                    label: Text("Question", textAlign: TextAlign.start),
                                  ),
                                  DataColumn(
                                    label: Text("Answer", textAlign: TextAlign.start),
                                  )
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Container(child: Text('Do you work in same room during infectious period*?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[6], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Shared work place air conditioned?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[7], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Work place poorly ventilated or crowded?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[8], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(0.0),
                              child: DataTable(
                                sortAscending: true,
                                sortColumnIndex: 0,
                                headingRowHeight: 0,
                                columnSpacing: 2,
                                dataRowHeight: 50,
                                columns: [
                                  DataColumn(
                                    label: Text("Question", textAlign: TextAlign.start),
                                  ),
                                  DataColumn(
                                    label: Text("Answer", textAlign: TextAlign.start),
                                  )
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Container(child: Text('Were you in a gathering (Ex - Meeting, Class, Discussion, Practical) with the index case during the infectious period*?', style: TextStyle(fontSize: 10.0),)),),
                                    DataCell(Container(child: Text(answers[9], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Was the room where the gathering was held filled to more than 50% of capacity?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[10], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Was the room where gathering was held air conditioned?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[11], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container(child: Text('Was the room where the gathering was held poorly ventilated', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[12], style: TextStyle(fontWeight: FontWeight.bold),),),),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container( child: Text('Was the gathering held for more than 15 min?', style: TextStyle(fontSize: 12.0),)),),
                                    DataCell(Container(child: Text(answers[13], style: TextStyle(fontWeight: FontWeight.bold),),),),
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
            ],
          ),
        )
    ),
    actions: [
      TextButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return commentDialog();
            },
          );
        },
        child: Text("Comment"),),
      TextButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        child: Text("Cancel"),),
    ],
  );

  // Comment Dialog Box

  AlertDialog commentDialog() => AlertDialog(
    title: Text("Comment on The Patient"),
    content: TextField(
      maxLines: 5,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter the Comment Here!',
      ),
      onChanged: (value) => _commentText = value,
    ),
    actions: [
      TextButton(
        onPressed: (){
          print("Comment Text: " + _commentText);
          _submitComment(_commentText);
          Navigator.pushReplacementNamed(context, '/secure/dashboard');
        },
        child: Text("Submit"),),
      TextButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        child: Text("Cancel"),),
    ],
  );

    // set up the Bell Icon List
  Widget _bellIconList() => Theme(
      data: Theme.of(context).copyWith(
        cardColor: Colors.white.withOpacity(0.8),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      child: PopupMenuButton<String>(
      itemBuilder: (context) =>
          _patientsNames.map((item) =>
              PopupMenuItem<String>(
                value: item.substring(0,item.indexOf(":")),
                child: Text(
                  "Tap to view patient Mr: " + item.substring(item.indexOf(":") + 1,) + "'s Risk Assessment Form",
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
              )).toList(),
      onSelected: (value) {
          setState(() {
            _patientId = int.parse(value);
            _setBellCounter(_patientsNames.length);
            _getPatientReport(_patientId);
          });
      },
    child: Stack(
          children: [
            Icon(Icons.notifications, size: 30, color: Colors.white,),
            Container(
                width: 35,
                height: 35,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 5),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffc32c37),
                      border: Border.all(color: Colors.white, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                      child: Text(
                        _counter.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
    ),)
  );
  String _generateContent(String content){
    List<String> answers = content.split(',');
    String formattedAnswers = "";
    int i = 1;
    for (var answer in answers) {
      formattedAnswers+= "\tQuestion " + i.toString() + " : " + answer + "\n";
      i+=1;
    }
    return formattedAnswers;
  }
  void _submitComment(String comment) async {
    var response = await http.post(Uri.parse(Constants.BASEURL + "/monitoring/doctorComment/"+ _patientId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      body: jsonEncode(comment),
    );
    if (response.statusCode == 200) {
      _showToast(context, 'Comment Submission Success!');
    } else{
      _showToast(context, 'Data Loading Failed!');

    }
  }

  void _getPatientReport(int patientId) async {
    var response = await http.get(Uri.parse(Constants.BASEURL + "/monitoring/patientRecords/"+ _patientId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
        });

    print(response.body);
    if (response.statusCode == 200) {
      _showToast(context, 'Data Loading Success!');
      print(response.body);
      PatientReportDTO patientReportDTO = PatientReportDTO.fromJson(jsonDecode(response.body));
      List<String> answersList =  patientReportDTO.report.split(",");
      List<String> basicQAnswersList =  patientReportDTO.basicQuestions.split(",");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert(patientReportDTO.patientName,basicQAnswersList, answersList, patientReportDTO.dateOfSubmission);
        },
      );
    } else {
      _showToast(context, 'Data Loading Failed!');
    }
  }


  //set up bell icon list Static List
  // Widget _bellIconList() => PopupMenuButton<int>(
  //   itemBuilder: (context) =>
  //   [
  //     PopupMenuItem(
  //       value: 1,
  //       child: Text("First"),
  //     ),
  //     PopupMenuItem(
  //       value: 2,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 3,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 4,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 5,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 6,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 6,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 6,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 6,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 6,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 6,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 6,
  //       child: Text("Second"),
  //     ),
  //     PopupMenuItem(
  //       value: 6,
  //       child: Text("Second"),
  //     ),
  //   ],
  //
  //   child: Stack(
  //     children: [
  //       Icon(Icons.notifications, size: 30, color: Colors.white,),
  //       Container(
  //           width: 35,
  //           height: 35,
  //           alignment: Alignment.topRight,
  //           margin: EdgeInsets.only(top: 5),
  //           child: Container(
  //             width: 15,
  //             height: 15,
  //             decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: Color(0xffc32c37),
  //                 border: Border.all(color: Colors.white, width: 1)),
  //             child: Padding(
  //               padding: const EdgeInsets.all(0.0),
  //               child: Center(
  //                 child: Text(
  //                   _counter.toString(),
  //                   style: TextStyle(fontSize: 10, color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //     ],
  //   ),
  // );

}
