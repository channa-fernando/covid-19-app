import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/dto/covidLiveDataDTO.dart';
import 'package:untitled/utility/constants.dart';

class CovidDetails extends StatefulWidget {
  const CovidDetails({Key? key}) : super(key: key);

  @override
  _CovidDetailsState createState() => _CovidDetailsState();
}

class _CovidDetailsState extends State<CovidDetails> {
  int _current = 0;
  List imgList = [
    'images/banner1.jpg',
    'images/banner2.jpg',
    'images/banner3.jpg',
    'images/banner4.jpg',
    'images/banner5.jpg'
  ];

  CovidLiveDataDTO covidLiveDataDTO = new CovidLiveDataDTO(success: false);
  @override
  void initState() {
    super.initState();
    covidLiveDataDTO = getCovidLiveUpdate();
    print(covidLiveDataDTO);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CarouselSlider(
            height: 250.0,
            aspectRatio: 16 / 9,
            initialPage: 0,
            enlargeCenterPage: true,
            autoPlay: true,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayAnimationDuration: Duration(milliseconds: 2000),
            pauseAutoPlayOnTouch: Duration(seconds: 5),
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
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
            height: 5.0,
          ),
          Container(
            width: 500,
            height: 50,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Confirmed Cases" ,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            width: 500,
            height: 50,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Confirmed Cases",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  CovidLiveDataDTO getCovidLiveUpdate() {
    http.get(
      Uri.parse(Constants.SL_HEALTH_COVID_ENDPOINT),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    ).then((response) {
      // print(response.body);
      if (response.statusCode == 200) {
        return CovidLiveDataDTO.fromJson(jsonDecode(response.body));

      } else {
        _showToast(context, 'Data Loading Failed!');
        String errorData = "{\"success\": true }";
        return CovidLiveDataDTO.fromJson(jsonDecode(errorData));
      }
    });
    String errorData = "{\"success\": true }";
    return CovidLiveDataDTO.fromJson(jsonDecode(errorData));
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
