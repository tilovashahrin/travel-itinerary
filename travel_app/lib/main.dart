//import 'package:flutt/home.page.dart';
import 'loginProgess/screens/login_screen.dart';
import 'loginProgess/screens/signup_screen.dart';
import 'loginProgess/screens/authentication.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'home_screen/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
//AuthService appAuth = new AuthService();
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authentication(),
        )
      ],
      child: MaterialApp(
        title: 'Login App',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          SignupScreen.routeName: (ctx)=> SignupScreen(),
          LoginScreen.routeName: (ctx)=> LoginScreen(),
          MainScreen.routeName: (ctx)=> MainScreen(),
        },
      ),
    );
  }
}
/*
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
}*/