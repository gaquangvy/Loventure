import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loventure/home_loventure.dart';
import 'package:loventure/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_data.dart';

void main() {
  runApp(Loventure());
}

class Loventure extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loventure by BaeVee',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Introduction(),
    );
  }
}

class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: GestureDetector(
        onTap: () {
          SharedPreferences.getInstance().then((pref) {
            var loginStatus = pref.getBool("login");
            if (loginStatus != null && loginStatus == true)
            {
              FirebaseAuth.instance.currentUser().then((value) {
                setState(() {
                  userID = value.uid;
                });
              }).catchError((onError) {});
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home())
              );
            }
            else
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn())
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home())
              );
            }
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Loventure",
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decorationColor: Colors.deepOrange
                ),
              ),
              Text(
                'By BaeVee',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 30
                )
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text("Tap anywhere to continue!"),
              )
            ],
          ),
        ),
      )
    );
  }
}

