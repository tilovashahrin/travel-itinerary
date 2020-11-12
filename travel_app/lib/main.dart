<<<<<<< HEAD
import 'home.page.dart';
=======
//import 'package:flutt/home.page.dart';
>>>>>>> e9d36d76803798735fbd448f364ed0be8ed7cf4d
import 'loginPage.dart';
import 'auth.service.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';

=======
>>>>>>> e9d36d76803798735fbd448f364ed0be8ed7cf4d
AuthService appAuth = new AuthService();

void main() async {
  // Set default home.
  LoginPage();
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

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          print("Error initiating firebase");
          return Text('Error initializing firebase');
        }
        if(snapshot.connectionState == ConnectionState.done){
          return MaterialApp(
          title: 'App',
          routes: <String, WidgetBuilder>{
              // Set routes for using the Navigator.
              '/home': (BuildContext context) => new MainScreen(),
              '/login': (BuildContext context) => new LoginPage(),
          },
          );
        }else{
          return LinearProgressIndicator();
        }
      },
    );
  }
}