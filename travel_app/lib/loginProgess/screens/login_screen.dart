import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'package:travel_app/loginProgess/models/authentication.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email' : '',
    'password': ''
  };

  void _showErrorDialog(String msg)
  {
    showDialog(
        context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text(msg),
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

  Future<void> _submit() async
  {
    if(!_formKey.currentState.validate())
      {
        return;
      }
    _formKey.currentState.save();

    try{
      await Provider.of<Authentication>(context, listen: false).logIn(
          _authData['email'],
          _authData['password']
      );
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

    } catch (error)
    {
      var errorMessage = 'Authentication Failed. Please try again later.';
      _showErrorDialog(errorMessage);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
     appBar: AppBar(
       backgroundColor: Color(0x44000000),
       elevation: 0,
        //title: Text('Login'),
       actions: <Widget>[
         FlatButton(
           child: Row(
             children: <Widget>[
              Text('Signup'),
               Icon(Icons.person_add)
             ],
           ),
           textColor: Colors.white,

           onPressed: (){
             Navigator.of(context).pushReplacementNamed(SignupScreen.routeName);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/loginbg.jpg'),
                fit: BoxFit.cover,
              ),

            ),

          ),

          Text(

            '\n\n        Welcome to Your \n               Journey',
            style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontStyle:FontStyle.italic),
          ),
          Center(

            child: Card(
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 260,
                width: 300,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
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
                            _authData['email'] = value;
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
                            _authData['password'] = value;
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
                            _submit();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                        ),
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
