import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firebase_data.dart';
import 'add_story.dart';

class Story extends StatefulWidget {
  Story({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StoryPage createState() => _StoryPage();
}

class _StoryPage extends State<Story> {
  var story = TextEditingController();
  Map storyList;

  Expanded _storyDisplay(Map stories) {
    if (stories == null) {
      return Expanded(
        child: Center(
          child: Text(
            'There is no story line!\nWhy don\'t you write some?'
          ),
        ),
      );
    }
    else {
      var storyDates = storyList.keys.toList();
      storyDates.sort();
      return Expanded(
        child: ListView.builder(
          itemCount: storyList.keys.toList().length,
          itemBuilder: (BuildContext context, int index) {
            String date = storyDates[index];
            DateTime formattedDate = DateTime.parse(date);
            return Container(
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
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      formattedDate.month.toString() + "/" + formattedDate.day.toString() + "/" + formattedDate.year.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: storyList[date].values.toList().length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          border: Border.all(
                            color: Colors.black,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey,
                              offset: new Offset(10.0, 10.0),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                        child: Text(
                          storyList[date].values.toList()[index],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  _StoryPage() {
    _refreshStory();
    FirebaseDatabase.instance.reference().child(userID + "/story").onChildAdded.listen((event) {
      _refreshStory();
    });
  }

  void _refreshStory() {
    FirebaseDatabase.instance.reference().child(userID + "/story").once()
        .then((snapData) {
          storyList = snapData.value;
          setState(() {});
        }).catchError((onError) {
          print("Loading stories failed");
        });
  }

  @override
  Widget build(BuildContext context) {

    print(storyList);
    setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loventure: Story',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.red[100],
      body: Column(
        children: [
          _storyDisplay(storyList),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: story,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Diary',
                    prefixIcon: Icon(Icons.message)
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  DateTime current = DateTime.now();
                  String dateStory = (current.year*10000 + current.month*100 + current.day).toString();
                  String timePunch = (current.millisecondsSinceEpoch).toString();
                  if (story.text != "")
                    FirebaseDatabase.instance.reference().child(userID + '/story/' + dateStory).update({timePunch : story.text}).then((value) {
                      story.text = "";
                    }).catchError((onError) {
                      story.text = "";
                    });
                    setState(() {});
                },
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: RaisedButton.icon(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStory())
          );
        },
        color: Colors.blueAccent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        label: Text('Add Story on Another Day',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.assignment,
          color:Colors.white,
        ),
        textColor: Colors.white,
        splashColor: Colors.red,
      ),
    );
  }
}