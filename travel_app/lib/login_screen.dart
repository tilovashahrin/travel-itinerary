import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_app/classes/demo_localization.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'loginProgess/screens/authentication.dart';
import 'package:flutter/material.dart';
import 'loginProgess/screens/language.dart';
import 'main.dart';
//import 'packages:localization/routes/routes_names';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
   'Email' : '',
    'password': ''
  };

  void _showErrorDialog(String msg)
  {
    showDialog(
        context: context,
      builder: (ctx) => AlertDialog(
        title: Text(DemoLocalization.of(context).getTranslatedValue('Err')),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            child: Text(DemoLocalization.of(context).getTranslatedValue('K')),
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
          _authData[DemoLocalization.of(context).getTranslatedValue('_Email')],
          _authData[DemoLocalization.of(context).getTranslatedValue('_Password')]
      );
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

    } catch (error)
    {
      var errorMessage = DemoLocalization.of(context).getTranslatedValue('Auth');
      _showErrorDialog(errorMessage);
    }

  }
  void _changeLanguage(Language language) {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, 'CA');
        break;
      case 'hi':
        _temp = Locale(language.languageCode, 'IN');
        break;
      case 'ja':
        _temp = Locale(language.languageCode, 'JP');
        break;
      case 'ru':
        _temp = Locale(language.languageCode, 'RU');
        break;
      default:
        _temp = Locale(language.languageCode, 'CA');
    }
    MyApp.setLocale(context,_temp);
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
         Padding(
           padding: const EdgeInsets.only(
             left: 10.0,
             top: 0,
             right: 0.0,
             bottom: 5.0,
           ),
           child: DropdownButton(
             onChanged: (Language language){
               _changeLanguage(language);
             },
             underline:SizedBox(),
             icon:Icon(

               Icons.language,color: Colors.white,
             ),
             items: Language.languageList()
                 .map<DropdownMenuItem<Language>>((lang)=> DropdownMenuItem(
               value:lang,
               child:Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children:<Widget>[ Text(lang.name, style: TextStyle(fontSize: 20),), Text(lang.flag)],
               ),
             )) .toList(),
           ),
         ),
         FlatButton(
           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
           child: Row(
             children: <Widget>[
              Text(DemoLocalization.of(context).getTranslatedValue('_Sign')),
               Icon(Icons.person_add)
             ],
           ),
           textColor: Colors.white,

           onPressed: (){
             Navigator.of(context).pushReplacementNamed(SignupScreen.routeName);
            },
          ),
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

            DemoLocalization.of(context).getTranslatedValue('_Intro'),
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
                height: 360,
                width: 300,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        //email
                        TextFormField(
                          decoration: InputDecoration(labelText: DemoLocalization.of(context).getTranslatedValue('_Email'),prefixIcon: Icon(
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
                                return DemoLocalization.of(context).getTranslatedValue('InvE');
                              }
                            return null;
                          },
                          onSaved: (value)
                          {
                            _authData[DemoLocalization.of(context).getTranslatedValue('_Email')] = value;
                          },


                        ),

                        //password
                        TextFormField(
                              decoration: InputDecoration(labelText: DemoLocalization.of(context).getTranslatedValue('_Password'),prefixIcon: Icon(
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
                                return DemoLocalization.of(context).getTranslatedValue('InvM');
                              }
                            return null;
                          },
                          onSaved: (value)
                          {
                            _authData[DemoLocalization.of(context).getTranslatedValue('_Password')] = value;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          child: Text(
                              DemoLocalization.of(context).getTranslatedValue('Sub')
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

