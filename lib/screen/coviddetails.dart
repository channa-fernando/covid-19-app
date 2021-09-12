import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/dto/covidUpdate.dart';
import 'package:untitled/utility/constants.dart';

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

  @override
  void initState() {
    super.initState();
    getCovidLiveUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
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
          Text(
            "Recent Numbers",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
            ),
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
    ));
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
}
