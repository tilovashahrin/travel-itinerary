import 'package:flutter/material.dart';
import 'login_screen.dart';
class HomeScreen extends StatelessWidget {

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar (
          backgroundColor: Color(0x44000000),
          elevation: 0,
    //title: Text('Login'),
    actions: <Widget>[
    FlatButton(
    child: Row(
    children: <Widget>[
    Text('Logout'),
    Icon(Icons.person_add)
    ],
    ),
    textColor: Colors.white,

    onPressed: (){
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    },
    )
    ],
      )
    );
  }
}
