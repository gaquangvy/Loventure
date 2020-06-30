import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loventure/firebase_data.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DateTime _dateEvent;
  final _eventContent = TextEditingController();
  String _alert = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Story on Another Day',
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InputDatePickerFormField(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now().add(Duration(days: 1)),
                  onDateSubmitted: (date) {
                    setState(() {
                      _dateEvent = date;
                    });
                  },
                  fieldLabelText: "Date Story: ",
                  fieldHintText: "Formatted in mm/dd/yyyy",
                ),
                TextField(
                  controller: _eventContent,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Story',
                  ),
                  scrollPhysics: ScrollPhysics(),
                  maxLengthEnforced: true,
                ),
                Text(
                  _alert,
                )
              ]
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_eventContent.text != "")
            FirebaseDatabase.instance.reference().child(userID + '/events/otherEvents/').update({_eventContent.text : _dateEvent.toString()}).then((value) {
              _eventContent.text = "";
              Navigator.pop(context);
            }).catchError((onError) {
              _eventContent.text = "";
              print("error!");
            });
          setState(() {});
        },
        child: Icon(
          Icons.add_circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
