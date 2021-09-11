import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/dto/loginResponseDTO.dart';
import 'package:untitled/utility/constants.dart';
import 'package:untitled/utility/widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _userName = "";
  String _passWord = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var doLogin = () async {
      final form = formKey.currentState;

      if (form != null && form.validate()) {
        form.save();

        final Map<String, dynamic> requestBody = {
          "email": _userName,
          "passWord": _passWord,
        };

        var response = await http.post(
          Uri.parse(Constants.BASEURL),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        );

        print(response.body);
        if (response.statusCode == 200) {
            _showToast(context, 'Login Success!');
            LoginResponseDTO loginResponseDTO = LoginResponseDTO.fromJson(jsonDecode(response.body));
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('userId', loginResponseDTO.userId);
            prefs.setString('token', loginResponseDTO.token);
            prefs.setString('userName', loginResponseDTO.userName);
            prefs.setString('address', loginResponseDTO.address);
            Navigator.pushReplacementNamed(context, '/secure/dashboard');

        } else {
            _showToast(context, 'Bad Credentials!');
          }
      }
      else {
        _showToast(context, 'Please Resubmit Registration Details!');
      }
    };

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        FlatButton(
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                Text("Email"),
                SizedBox(
                  height: 5.0,
                ),
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
                SizedBox(
                  height: 8.0,
                ),
                forgotLabel
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
