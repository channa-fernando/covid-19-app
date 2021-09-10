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
                Text("Email"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                  value!.isEmpty ? "Please Enter Password" : null,
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
                  autofocus: false,
                  obscureText: true,
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
