import 'package:firebase_database/firebase_database.dart';

String userID;
void createData(String id) {
  FirebaseDatabase.instance.reference().child(id).set(
      {
        "you" : {
          "nickname" : "name",
          "birthday" : DateTime.now().toString(),
          "profile" : "http://",
          "horoscope" : "Taurus",
          "gender" : "M"
        },
        "partner" : {
          "nickname" : "name",
          "birthday" : DateTime.now().toString(),
          "profile" : "http://",
          "horoscope" : "Taurus",
          "gender" : "M"
        },
        "status" : "single",
        "cover" : {
          "coverAvailable" : "no"
        },
        "firstdate" : DateTime.now().toString(),
        "album" : {},
        "story" : {}
      }
  );
}