import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utility/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/utility/constants.dart';
import 'dart:convert';

class SubmitReadings extends StatefulWidget {
  const SubmitReadings({Key? key}) : super(key: key);

  @override
  _SubmitReadingsState createState() => _SubmitReadingsState();
}

class _SubmitReadingsState extends State<SubmitReadings> {
  final formKey = GlobalKey<FormState>();
  String _userName = "";
  String _passWord = "";
  String _emergencyContact = "";
  String _address = "";

  String _category = 'Home Quarantine Patient';
  var categoryList = [
    'Home Quarantine Patient',
    'Home Quarantine Close Contact'
  ];

  @override
  Widget build(BuildContext context) {
    var doLogin = () {
      final form = formKey.currentState;

      if (form != null && form.validate()) {
        form.save();

        final Map<String, dynamic> requestBody = {
          "email": _userName,
          "passWord": _passWord,
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
                Text("Category"),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            color: Colors.grey, style: BorderStyle.solid, width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _category,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          elevation: 16,
                          items: categoryList.map((String categorySelected) {
                            return DropdownMenuItem(value: categorySelected, child: Text(categorySelected,));
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
                  decoration: buildInputDecoration("Please Enter Address!", Icons.location_on),
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
                  decoration: buildInputDecoration("Enter Emergency Contact!", Icons.phone),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey, style: BorderStyle.solid, width: 0.80),
                    ),
                  child: Text("Password"),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                  value!.isEmpty ? "Please Enter Password" : null,
                  onSaved: (value) => _passWord = value!,
                  decoration:
                  buildInputDecoration("Enter Password!", Icons.lock),
                ),
                SizedBox(
                  height: 20.0,
                ),
                longButtons("Login", doLogin),

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

