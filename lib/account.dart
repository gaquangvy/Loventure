import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_data.dart';
import 'signin.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.currentUser().then((value) {
      userID = value.uid;
      print(userID);
      setState(() {

      });
    }).catchError((onError) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Column(
        children: <Widget>[
          Image(
              image: NetworkImage("https://cdn.pixabay.com/photo/2018/01/04/19/43/love-3061483_960_720.jpg")
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                    'User ID: ',
                    style: TextStyle(fontSize: 30)
                ),
                Text(
                    userID,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    )
                ),
                FlatButton(
                  onPressed: () {
                    userID = "";
                    SharedPreferences.getInstance().then((pref) {
                      pref.setBool("login", false);
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn())
                    );
                  },
                  child: Text(
                      'Logout',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
