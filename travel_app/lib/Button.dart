import 'package:flutter/material.dart';
<<<<<<< HEAD
//import 'package:flutter/auth.service.dart';
=======
import 'auth.service.dart';
>>>>>>> e9d36d76803798735fbd448f364ed0be8ed7cf4d

//login button
import 'main.dart';
class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.cyan[500],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: new RaisedButton(
            child: new Text(
                'Login for App)'
            ),
            onPressed: () {
              appAuth.login().then((result) {
                if (result) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              });
            }
        ),
      ),
    );
  }


}