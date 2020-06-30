import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loventure/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_data.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  String alert = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-In'),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 30.0, bottom: 5.0, left: 40.0, right: 40.0),
                      child: TextField(
                        controller: emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 40.0, right: 40.0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    )
                  ],
                ),
                FlatButton(
                  onPressed: () {

                  },
                  child: Text(
                      'Forgetting Password?',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: RaisedButton.icon(
                        onPressed: () {
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text
                          ).then((value) {
                            SharedPreferences.getInstance().then((pref) {
                              pref.setBool("login", true);
                            });
                            FirebaseAuth.instance.currentUser().then((value) {
                              setState(() {
                                userID = value.uid;
                              });
                            }).catchError((onError) {});
                            Navigator.pop(context);
                          }).catchError((onError) {
                            setState(() {
                              alert = onError.message;
                            });
                            print(onError.toString());
                          });
                        },
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        label: Text('Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.assignment_ind,
                          color:Colors.white,
                        ),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp())
                          );
                        },
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        label: Text('Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.assignment,
                          color:Colors.white,
                        ),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              alert,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18
              ),
            ),
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          )
        ],
      ),
    );
  }
}
