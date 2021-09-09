import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/utility/constants.dart';
import 'package:untitled/utility/widgets.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _userName = "";
  String _passWord = "";
  String _confirmPassWord = "";
  String _contactNumber = "";
  String _contactNumberPHI = "";
  String _nearestPoliceStation = "";
  String _gramaSewaWasam = "";
  String _fullName = "";
  String _address = "";

  final formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  String dropdownvalue = 'Apple';
  var items = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'watermelon',
    'Pineapple'
  ];

  @override
  Widget build(BuildContext context) {
    var doRegister = () {
      final form = formKey.currentState;

      if (form != null && form.validate()) {
        form.save();

        final Map<String, dynamic> requestBody = {
          "fullName": _fullName,
          "email": _userName,
          "passWord": _passWord,
          "address": _address,
          "contactNumber": _contactNumber,
          "contactNumberPHI": _contactNumberPHI,
          "gramaSewa": _gramaSewaWasam,
          "policaStation": _nearestPoliceStation
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
            _showToast(context,
                'User Registration Success! Please Login with credentials');
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            _showToast(context, 'Gateway failure! Please try again later');
          }
        });
      } else {
        _showToast(context, 'Please Resubmit Registration Details!');
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Text("Full Name"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value!.isEmpty ? "Your Full Name is Required!" : null,
                  onSaved: (value) => _fullName = value!,
                  decoration:
                      buildInputDecoration("Enter Full Name", Icons.person),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Address"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value!.isEmpty ? "Your Address is Required!" : null,
                  onSaved: (value) => _address = value!,
                  decoration: buildInputDecoration(
                      "Enter Your Address", Icons.location_on),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Contact Number"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) => value!.isEmpty
                      ? "Your Contact Number is Required!"
                      : null,
                  onSaved: (value) => _contactNumber = value!,
                  decoration: buildInputDecoration(
                      "Enter Your Contact Number", Icons.phone),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Contact Number PHI Officer"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) => value!.isEmpty
                      ? "Your PHI Officer's Contact Number is Required!"
                      : null,
                  onSaved: (value) => _contactNumberPHI = value!,
                  decoration: buildInputDecoration(
                      "Enter Your PHI Officer's Contact Number", Icons.phone),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Grama Sewa Wasam"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) => value!.isEmpty
                      ? "Your Grama Sewa Wasam Name is Required!"
                      : null,
                  onSaved: (value) => _gramaSewaWasam = value!,
                  decoration: buildInputDecoration(
                      "Enter Your Grama Sewa Wasam Name", Icons.perm_identity),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Nearest Police Station"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) => value!.isEmpty
                      ? "Your Nearest Police Station is Required!"
                      : null,
                  onSaved: (value) => _nearestPoliceStation = value!,
                  decoration: buildInputDecoration(
                      "Enter Your Nearest Police Station Name",
                      Icons.local_police_outlined),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Email"),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      EmailValidator.validate(value!) ? null : "Invalid Email!",
                  onSaved: (value) => _userName = value!,
                  decoration: buildInputDecoration("Enter Email!", Icons.email),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Password"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  controller: _pass,
                  autofocus: false,
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? "Your Password is Required!" : null,
                  onSaved: (value) => _passWord = value!,
                  decoration:
                      buildInputDecoration("Enter Password!", Icons.lock),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Confirm Password"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  controller: _confirmPass,
                  autofocus: false,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Confirm Password";
                    } else if (value != _pass.text) {
                      return "Mismatch confirm password";
                    }
                    return null;
                  },
                  onSaved: (value) => _confirmPassWord = value!,
                  decoration: buildInputDecoration(
                      "Enter Confirm Password!", Icons.lock),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Please Select Your District"),
                SizedBox(
                  height: 5.0,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: dropdownvalue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
                longButtons('Register', doRegister),
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
