//import 'package:flutt/home.page.dart';
import 'loginPage.dart';
import 'auth.service.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';
AuthService appAuth = new AuthService();

void main() async {
  // Set default home.
  Widget _defaultHome = new LoginPage();

  // Get result of the login function.
  bool _result = await appAuth.login();
  if (_result) {
    _defaultHome = new MainScreen();
  }

  // Run app!
  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) =>  new MainScreen(),
      '/login': (BuildContext context) => new LoginPage()
    },
  ));
}