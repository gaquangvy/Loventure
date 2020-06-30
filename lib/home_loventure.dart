import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'albums.dart';
import 'events.dart';
import 'firebase_data.dart';
import 'picture_upload.dart';
import 'story.dart';
import 'setting.dart';
import 'account.dart';
import 'calculation_format.dart';

class Home extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home> {
  final dataRef = FirebaseDatabase.instance.reference().child(userID);
  Map data = {};
  int days;
  Image cover;
  bool coverAvailable;
  Person you;
  Person partner;
  Map drawerList = {'Stories' : [Icons.border_color, Story()],
    "Albums" : [Icons.photo_album, Albums()],
    "Events" : [Icons.event, Events()],
    "Account" : [Icons.account_box, Account()],
  };
  bool single;
  String notification = "";

  _HomePage() {
    dataRef.once().then((value) {
      setState(() {
        data.addAll(value.value);
        coverAvailable = data["cover"]["coverAvailable"] == "yes";
        cover = Image(
          image: NetworkImage(data["cover"]["cover"]),
        );
        days = DateTime.now().difference(DateTime.parse(data["firstdate"])).inDays;
        var youProfile = data["you"];
        you = Person(
            birthday: DateTime.parse(youProfile["birthday"]),
            gender: youProfile["gender"],
            horoscope: youProfile["horoscope"],
            nickname: youProfile["nickname"],
            profile: youProfile["profile"]
        );
        single = data["status"] == "single" ? true : false;
        if (!single) {
          var partnerProfile = data["partner"];
          partner = Person(
              birthday: DateTime.parse(partnerProfile["birthday"]),
              gender: partnerProfile["gender"],
              horoscope: partnerProfile["horoscope"],
              nickname: partnerProfile["nickname"],
              profile: partnerProfile["profile"]
          );
        }
        notification = "";
        data["events"].forEach((k,v) {
          v.forEach((x,y) {
            if (DateTime.now().difference(DateTime.parse(y)).inDays == 0)
              notification += x + ", ";
          });
        });
      });
    }).catchError((onError) => null);
  }

  Expanded _personProfile(Person person, String link) {
    return Expanded(
      flex: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onLongPress: () async {
              final result = await Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => ImageCapture()),
              );
              dataRef.child(link).update(
                  {
                    "profile" : result
                  }
              ).then((value){}).catchError((onError) {});
              person.profile = result;
              print(result);
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(person.profile),
            ),
          ),
          RaisedButton(
            onPressed: (){},
            child: Text(
              person.nickname + ", "+ getAge(person.birthday).toString(),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            color: Colors.black,
            textColor: Colors.yellow,
            splashColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          RaisedButton(
            onPressed: (){},
            child: Text(
              person.gender + ", " + person.horoscope,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            color: Colors.red,
            textColor: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          )
        ],
      ),
    );
  }

  Column _loveCounting() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onLongPress: () async {
              final result = await Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => ImageCapture()),
              );
              dataRef.child("cover").update(
                  {
                    "coverAvailable" : "yes",
                    "cover" : result
                  }
              ).then((value) {}).catchError((onError) {});
            },
            child: coverAvailable ?
              Container(
                height: 300,
                child: cover,
              ) :
              Container(
                child: Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                  size: heartSize(days) * 1.0,
                ),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                howManyDays(days),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (notification != "")
            Text(
                "Happy " + notification
            )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Loventure",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.red[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 50,
              child: _loveCounting()
            ),
            Expanded(
              flex: 50,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _personProfile(you, "/you"),
                    if (!single)
                      _personProfile(partner, "/partner"),
                  ],
                )
              ),
            )
          ],
        ),
      ),
      drawer: Container(
        padding: EdgeInsets.only(top: 30.0),
        child: ListView.builder(
            itemCount: drawerList.keys.toList().length,
            itemBuilder: (BuildContext context, int index) {
              var titleDrawer = drawerList.keys.toList()[index];
              return Container(
                margin: EdgeInsets.all(20.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                          drawerList[titleDrawer][0],
                          color: Colors.redAccent
                      ),
                      Text(
                          " " + titleDrawer,
                          style: TextStyle(
                              fontSize: 30
                          )
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => drawerList[titleDrawer][1]),
                    );
                  },
                ),
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
          setState(() {});
        },
        child: Icon(
          Icons.storage,
          color: Colors.white,
        ),
      ),
    );
  }
}