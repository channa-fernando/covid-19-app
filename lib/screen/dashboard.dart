import 'package:flutter/material.dart';
import 'package:untitled/screen/googlemap.dart';
import 'package:untitled/screen/submitreadings.dart';
import 'package:untitled/screen/mapPopup.dart';

import 'coviddetails.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0; //New
  final _pageOptions = [CovidDetails(), SubmitReadings(locationSelectedFromMap: '',), MapView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 38, ),
        selectedItemColor: Colors.white,

        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        currentIndex: _selectedIndex,
        //New
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            label: 'Report Incident',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Contact Tracing',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
