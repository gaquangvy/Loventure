import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loventure/addEvent.dart';
import 'package:loventure/firebase_data.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final databaseReference = FirebaseDatabase.instance.reference().child(userID);
  var _birthdays;
  var _otherEvents;
  var anniversaries;

  Map _holidays = {
    "New Year's Day" : DateTime(DateTime.now().year, 1, 1).toString(),
    "Valentines' Day" : DateTime(DateTime.now().year, 2, 14).toString(),
    "Mothers' Day" : DateTime(DateTime.now().year, 5, 10).toString(),
    "Fathers' Day" : DateTime(DateTime.now().year, 6, 21).toString(),
    "Thanksgiving's Day" : DateTime(DateTime.now().year, 11, 26).toString(),
    "Halloween" : DateTime(DateTime.now().year, 11, 30).toString(),
    "Christmas' Eve" : DateTime(DateTime.now().year, 12, 24).toString(),
    "Christmas' Day" : DateTime(DateTime.now().year, 12, 25).toString(),
    "New Year's Eve" : DateTime(DateTime.now().year, 12, 31).toString(),
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      databaseReference.child("events").once()
          .then((dataSnap) {
        setState(() {
          anniversaries = dataSnap.value["anniversaries"];
          _birthdays = dataSnap.value["birthdays"];
          _otherEvents = dataSnap.value["otherEvents"];
        });
      }).catchError((onError) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance.reference().child(userID + "/events").update({
      "holidays" : _holidays,
    }).then((value) {
      print("Succeeded!");
    })
    .catchError((onError) {
      print("Nope!");
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dates to Remember!'
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(30.0),
            padding: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Anniversaries',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: anniversaries.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String anniversary = anniversaries.keys.toList()[index];
                    DateTime anniversaryDate = DateTime.parse(anniversaries[anniversary]);
                    return Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: RaisedButton(
                        onPressed: () {

                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              anniversary + " - "
                            ),
                            Text(
                              anniversaryDate.month.toString() + "/" + anniversaryDate.day.toString() + "/" + anniversaryDate.year.toString()
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(30.0),
            padding: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Holidays',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _holidays.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String holiday = _holidays.keys.toList()[index];
                    DateTime holidayDate = DateTime.parse(_holidays[holiday]);
                    return Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: RaisedButton(
                        onPressed: () {

                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                                holiday + " - "
                            ),
                            Text(
                                holidayDate.month.toString() + "/" + holidayDate.day.toString() + "/" + holidayDate.year.toString()
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(30.0),
            padding: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Birthdays',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _birthdays.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String birthday = _birthdays.keys.toList()[index];
                    DateTime birthDate = DateTime.parse(_birthdays[birthday]);
                    return Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: RaisedButton(
                        onPressed: () {

                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                                birthday + " - "
                            ),
                            Text(
                                birthDate.month.toString() + "/" + birthDate.day.toString() + "/" + birthDate.year.toString()
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(30.0),
            padding: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Other Events',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                if (_otherEvents != null)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _otherEvents.keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      String otherDay = _otherEvents.keys.toList()[index];
                      DateTime otherDate = DateTime.parse(_otherEvents[otherDay]);
                      return Container(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: RaisedButton(
                          onPressed: () {

                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                  otherDay + " - "
                              ),
                              Text(
                                  otherDate.month.toString() + "/" + otherDate.day.toString() + "/" + otherDate.year.toString()
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => AddEvent()),
          );
        },
        child: Icon(
          Icons.add_alarm,
          color: Colors.white,
        ),
      ),
    );
  }
}
