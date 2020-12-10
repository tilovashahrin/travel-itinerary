import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'loginProgess/screens/authentication.dart';
import 'dart:io';
import 'home_screen.dart';
import 'login_screen.dart';

//starts the sign up stateful widget, inspired by flutter demos on how to create a form
//https://flutter.dev/docs/cookbook/forms/validation
class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController passwordCon = new TextEditingController();

  //creates authentication for email and password
  Map<String, String> auth = {
    'email' : '',
    'password' : ''
  };

  //exception if an error occurs
  // ignore: non_constant_identifier_names
  void Error(String errmsg)
  {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occured'),
          content: Text(errmsg),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: (){
                Navigator.of(ctx).pop();
              },
            )
          ],
        )
    );
  }
//submit button
  Future<void> _sub() async
  {
    if(!formKey.currentState.validate()) //validates and saves
      {
        return;
      }
    formKey.currentState.save();

    try{
      await Provider.of<Authentication>(context, listen: false).signUp( //authentication to sign up for email and pass
          auth['email'],
          auth['password']
      );
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

    } catch(error)
    {
      var errorMessage = 'Authentication Failed. Please try again later.';  //if failed return
      Error(errorMessage);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //title: Text('Signup'),
        backgroundColor: Color(0x44000000),
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text('Login'), //button to login
                Icon(Icons.person)
              ],
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/loginbg1.jpg'), //background image
                fit: BoxFit.cover,
              ),

            ),

          ),
          Center(
            child: Card( //inspired  from same flutter https://api.flutter.dev/flutter/material/Card-class.html
              elevation: 0,
              color: Colors.transparent,  //make card transparent
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 500,
                width: 300,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        //email
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email',prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                              size: 40),labelStyle:
                        new TextStyle(color: Colors.white, fontSize: 20.0)),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          validator: (value)
                          {
                            if(value.isEmpty || !value.contains('@'))
                            {
                              return 'invalid email';
                            }
                            return null;
                          },
                          onSaved: (value)
                          {
                            auth['email'] = value;
                          },
                        ),

                        //password
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password',prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40),labelStyle:
                          new TextStyle(color: Colors.white, fontSize: 20.0)),

                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          controller: passwordCon,
                          validator: (value)
                          {
                            if(value.isEmpty || value.length<=5)
                            {
                              return 'invalid password';
                            }
                            return null;
                          },
                          onSaved: (value)
                          {
                            auth['password'] = value;
                          },
                        ),

                        //Confirm Password
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Confirm Password',prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40),labelStyle:
                          new TextStyle(color: Colors.white, fontSize: 20.0)),

                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          validator: (value)
                          {
                            if(value.isEmpty || value != passwordCon.text)
                            {
                              return 'invalid password'; //returns invalid if password is invalid
                            }
                            return null;
                          },
                          onSaved: (value)
                          {

                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          child: Text(
                              'Submit'
                          ),
                          onPressed: ()
                          {
                            _sub();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
