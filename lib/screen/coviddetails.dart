import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/dto/covidUpdate.dart';
import 'package:untitled/utility/constants.dart';
import 'package:untitled/utility/widgets.dart';

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

  var doSubmit = (){};

  @override
  void initState() {
    super.initState();
    getCovidLiveUpdate();
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
                      Text("Protect YourSelf",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 23.0),),
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
                  autoPlayInterval: Duration(seconds: 2),
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

}
