//import 'package:flutt/home.page.dart';
import 'package:travel_app/classes/demo_localization.dart';

import 'login_screen.dart';
import 'signup_screen.dart';
import 'loginProgess/screens/authentication.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'home_screen/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
//AuthService appAuth = new AuthService();
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

static void setLocale(BuildContext context, Locale locale){
  _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
  state.setLocale(locale);
}
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale)
  {
    setState(() {
      _locale = locale;
    });
  }  @override

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authentication(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        locale: _locale,
        supportedLocales: [
          Locale('en','CA'),
          Locale('ja','JP'),
          Locale('ru','RU'),
          Locale('hi','IN'),
        ],
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale,supportedLocales){
          for(var locale in supportedLocales){
            if(locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode){
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
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