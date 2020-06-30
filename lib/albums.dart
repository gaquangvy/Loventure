import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loventure/add_photo.dart';
import 'package:loventure/album.dart';
import 'package:loventure/firebase_data.dart';

class Albums extends StatefulWidget {
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  final _databaseReference = FirebaseDatabase.instance.reference().child(userID);
  Map _albums;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _databaseReference.child("albums").once()
          .then((dataSnap) {
            setState(() {
              _albums = dataSnap.value;
            });
      })
          .catchError((onError){

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var albumList = _albums.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
      ),
      body: ListView(
        children: <Widget>[
            if (_albums != null) ListView.builder(
              shrinkWrap: true,
              itemCount: albumList.length,
              itemBuilder: (context, index) {
                String album = albumList[index];
                return Container(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Album(albumName: album)),
                      );
                    },
                    child: Text(
                      album,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                );
              }
            ),
            if (_albums == null) Text(
              "There is no album\nPlease add one!",
              style: TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.italic
              ),
            ),
          ],
        ),
      floatingActionButton: RaisedButton(
        child: Text('Add a photo'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPhoto()),
          );
          setState(() {

          });
        },
      ),
    );
  }
}
