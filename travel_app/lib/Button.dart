import 'package:flutter/material.dart';
import 'auth.service.dart';

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
            color: Colors.cyan,
            child: new Text(
                'Login'
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