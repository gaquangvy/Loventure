import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loventure/firebase_data.dart';

import 'picture_upload.dart';

class AddPhoto extends StatefulWidget {
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  var _photoName = TextEditingController();
  var _description = TextEditingController();
  var _albumName = TextEditingController();
  String _photoLink;
  DateTime _photoDate;
  String _alert;
  final _dataReference =  FirebaseDatabase.instance.reference().child(userID + "/albums");
  String _firstChoiceAlbum = "(Create an Album)";
  List<String> _albumList = <String>["(Create an Album)"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _dataReference.once().then((data) {
        if (data.value != null)
          _albumList = data.value.keys.toList();
        _albumList.add("(Create an Album)");
        print(_albumList);
      }).catchError((onError) {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _photoLink == null ? Container(
              height: 300,
              child: GestureDetector(
                onDoubleTap: () async {
                  final result = await Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => ImageCapture()),
                  );
                  setState(() {
                    _photoLink = result;
                    print(result);
                  });
                },
                child: RaisedButton(
                  onPressed: () {},
                  child: Text('Take a shot!'),
                ),
              ),
            ) :
            Container(
              height: 300,
              child: Image(
                image: NetworkImage(_photoLink),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                  controller: _photoName,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Photo\'s name',
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                  controller: _description,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  )
              ),
            ),
            InputDatePickerFormField(
              initialDate: DateTime.now(),
              firstDate: DateTime(1990),
              lastDate: DateTime.now().add(Duration(days: 1)),
              onDateSubmitted: (date) {
                setState(() {
                  _photoDate = date;
                });
              },
              onDateSaved: (date) {
                setState(() {
                  _photoDate = date;
                });
              },
              fieldLabelText: 'Date taken: ',
              fieldHintText: "Formatted in mm/dd/yyyy",
            ),
            if (_albumList != null)
              Row(
                children: <Widget>[
                  Text('Albums: '),
                  DropdownButton<String>(
                    value: _firstChoiceAlbum,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _firstChoiceAlbum = newValue;
                      });
                    },
                    items: _albumList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ],
              ),
            if (_firstChoiceAlbum == "(Create an Album)")
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                    controller: _albumName,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Album\'s Name',
                    )
                ),
              ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  String punch = DateTime.now().millisecondsSinceEpoch.toString();
                  _dataReference.child(_albumName.text + "/" + punch).update({
                    "name" : _photoName.text,
                    "link" : _photoLink,
                    "date" : _photoDate.toString(),
                    "description" : _description.text
                  }).then((value) {
                    print("succeeded!");
                    Navigator.pop(context);
                  })
                  .catchError((error) {
                    print(error);
                  });
                });
              },
              child: Text(
                'Add',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                ),
              ),
            ),
            if (_alert != null) Text(_alert),
          ],
        ),
      ),
    );
  }
}
