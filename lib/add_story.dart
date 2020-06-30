import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'firebase_data.dart';

class AddStory extends StatefulWidget {
  AddStory({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddStoryPage createState() => _AddStoryPage();
}

class _AddStoryPage extends State<AddStory> {
  DateTime _storyDate;
  final _storyContent = TextEditingController();
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
                      _storyDate = date;
                    });
                  },
                  fieldLabelText: "Date Story: ",
                  fieldHintText: "Formatted in mm/dd/yyyy",
                ),
                TextField(
                  controller: _storyContent,
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
          DateTime current = DateTime.now();
          String dateStory = (_storyDate.year*10000 + _storyDate.month*100 + _storyDate.day).toString();
          String timePunch = (current.millisecondsSinceEpoch).toString();
          if (_storyContent.text != "")
            FirebaseDatabase.instance.reference().child(userID + '/story/' + dateStory).update({timePunch : _storyContent.text}).then((value) {
              _storyContent.text = "";
              Navigator.pop(context);
            }).catchError((onError) {
              _storyContent.text = "";
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