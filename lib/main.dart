import 'package:flutter/material.dart';
import 'package:untitled/screen/dashboard.dart';
import 'package:untitled/screen/googlemap.dart';
import 'package:untitled/screen/login.dart';
import 'package:untitled/screen/register.dart';

main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Registration",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => DashBoard(),
        '/login':(context) => Login(),
        '/register':(context) => Register(),
        '/secure/dashboard' : (context) => DashBoard(),
        '/secure/map' : (context) => MapView()
      },);
  }
}



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// main() {
//   runApp(new MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Flutter Demo",
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Monitor Me"),
//           leading: IconButton(
//             icon: Icon(Icons.menu),
//             onPressed: () {},
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Icon(Icons.more_vert),
//               onPressed: () {},
//             ),
//           ],
//           bottom: TabBar(
//             tabs: [
//               Tab(
//                 icon: Icon(Icons.directions_bike),
//               ),
//               Tab(
//                 icon: Icon(Icons.dangerous),
//               ),
//               Tab(
//                 icon: Icon(Icons.ac_unit_outlined),
//               )
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             tab1(),
//             tab2(),
//             tab3(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget tab1(){
//   return Container(
//     child: Icon(Icons.directions_car),
//   );
// }
//
// Widget tab2(){
//   return Container(
//     child: Icon(Icons.directions_transit),
//   );
// }
//
// Widget tab3(){
//   return Container(
//     child: Icon(Icons.directions_bike),
//   );
// }
