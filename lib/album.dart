import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loventure/firebase_data.dart';

class Album extends StatefulWidget {
  Album({Key key, this.albumName}) : super(key: key);

  final String albumName;

  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  Map _photos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseDatabase.instance.reference().child(userID + "/albums/" + widget.albumName).once()
    .then((data) {
      setState(() {
        _photos = data.value;
      });
    }).catchError((error) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Album: " + widget.albumName),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: _photos.keys.length,
          itemBuilder: (context, index) {
            String photo = _photos.keys.toList()[index];
            Map photoDetail = _photos[photo];
            return Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: NetworkImage(photoDetail["link"]),
                      ),
                    ),
                    Text(
                      photoDetail['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                      ),
                    ),
                    Text(
                        photoDetail['description']
                    ),
                  ],
                )
            );
          }
      ),
    );
  }
}
