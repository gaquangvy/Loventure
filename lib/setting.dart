import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loventure/firebase_data.dart';
import 'calculation_format.dart';

enum Genders {male, female}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _nicknameController = TextEditingController();
  DateTime _birthday;
  Genders _gender;

  var _nicknameControllerPartner = TextEditingController();
  DateTime _birthdayPartner;
  Genders _genderPartner;

  var _single = false;
  DateTime _firstDateForStatus;

  Column _partnerProfile() {
    if (!_single) {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
                controller: _nicknameControllerPartner,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nickname',
                )
            ),
          ),
          InputDatePickerFormField(
            initialDate: DateTime.now(),
            firstDate: DateTime(1990),
            lastDate: DateTime.now().add(Duration(days: 1)),
            onDateSubmitted: (date) {
              setState(() {
                _birthdayPartner = date;
              });
            },
            onDateSaved: (date) {
              setState(() {
                _birthdayPartner = date;
              });
            },
            fieldLabelText: 'Birthday: ',
            fieldHintText: "Formatted in mm/dd/yyyy",
          ),
          if (_birthdayPartner != null)
            Text(
              'Horoscope: ' + getHoroscope(_birthdayPartner)
            ),
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: <Widget>[
                Radio(
                  value: Genders.male,
                  groupValue: _genderPartner,
                  onChanged: (Genders value) {
                    setState(() {
                      _genderPartner = value;
                    });
                  },
                ),
                Text(
                  'Male',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
                Radio(
                  value: Genders.female,
                  groupValue: _genderPartner,
                  onChanged: (Genders value) {
                    setState(() {
                      _genderPartner = value;
                    });
                  },
                ),
                Text(
                  'Female',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    else return Column();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                value: _single,
                onChanged: (value) {
                  setState(() {
                    _single = value;
                  });
                },
              ),
              Text(
                'Single? (Checked as Yes)',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                    controller: _nicknameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nickname',
                    )
                ),
              ),
              InputDatePickerFormField(
                initialDate: DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime.now().add(Duration(days: 1)),
                onDateSubmitted: (date) {
                  setState(() {
                    _birthday = date;
                  });
                },
                onDateSaved: (date) {
                  setState(() {
                    _birthday = date;
                  });
                },
                fieldLabelText: 'Birthday: ',
                fieldHintText: "Formatted in mm/dd/yyyy",
              ),
              if (_birthday != null)
                Text(
                    'Horoscope: ' + getHoroscope(_birthday)
                ),
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: Genders.male,
                      groupValue: _gender,
                      onChanged: (Genders value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    Text(
                      'Male',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                    Radio(
                      value: Genders.female,
                      groupValue: _gender,
                      onChanged: (Genders value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    Text(
                      'Female',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _partnerProfile(),
          InputDatePickerFormField(
            initialDate: DateTime.now(),
            firstDate: DateTime(1990),
            lastDate: DateTime.now().add(Duration(days: 1)),
            onDateSubmitted: (date) {
              setState(() {
                _firstDateForStatus = date;
              });
            },
            onDateSaved: (date) {
              setState(() {
              _firstDateForStatus = date;
              });
            },
            fieldLabelText: 'First Date for ' + (_single ? "Single" : "In Love") + ' ',
            fieldHintText: "Formatted in mm/dd/yyyy",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            FirebaseDatabase.instance.reference().child(userID).update(
                {
                  "status" : (_single) ? "single" : "in love",
                  'firstdate' : _firstDateForStatus.toString()
                }
            );
            FirebaseDatabase.instance.reference().child(userID + "/you").update(
                {
                  "nickname" : _nicknameController.text,
                  "birthday" : _birthday.toString(),
                  "profile" : "https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png",
                  "horoscope" : getHoroscope(_birthday),
                  "gender" : (_gender == Genders.male) ? "M" : "F"
                }
            );
            FirebaseDatabase.instance.reference().child(userID + "/events/birthdays").update(
                {
                  "yourbirthday" : _birthday.toString(),
                }
            );
            if (!_single) {
              FirebaseDatabase.instance.reference().child(userID + "/partner").update(
                  {
                    "nickname" : _nicknameControllerPartner.text,
                    "birthday" : _birthdayPartner.toString(),
                    "profile" : "https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png",
                    "horoscope" : getHoroscope(_birthdayPartner),
                    "gender" : (_genderPartner == Genders.male) ? "M" : "F"
                  }
              );
              FirebaseDatabase.instance.reference().child(userID + "/events/birthdays").update(
                  {
                    "otherbirthday" : _birthdayPartner.toString(),
                  }
              );
            }
            FirebaseDatabase.instance.reference().child(userID + "/events/anniversaries").update(
                {
                  "100 days" : _firstDateForStatus.add(Duration(days: 100)).toString(),
                  "200 days" : _firstDateForStatus.add(Duration(days: 200)).toString(),
                  "500 days" : _firstDateForStatus.add(Duration(days: 500)).toString(),
                  "1000 days" : _firstDateForStatus.add(Duration(days: 1000)).toString(),
                  "1 month" : DateTime(_firstDateForStatus.year, _firstDateForStatus.month+1, _firstDateForStatus.day).toString(),
                  "2 months" : DateTime(_firstDateForStatus.year, _firstDateForStatus.month+2, _firstDateForStatus.day).toString(),
                  "3 months" : DateTime(_firstDateForStatus.year, _firstDateForStatus.month+3, _firstDateForStatus.day).toString(),
                  "6 months" : DateTime(_firstDateForStatus.year, _firstDateForStatus.month+6, _firstDateForStatus.day).toString(),
                  "1 year" : DateTime(_firstDateForStatus.year+1, _firstDateForStatus.month, _firstDateForStatus.day).toString(),
                  "2 years" : DateTime(_firstDateForStatus.year+2, _firstDateForStatus.month, _firstDateForStatus.day).toString(),
                  "3 years" : DateTime(_firstDateForStatus.year+3, _firstDateForStatus.month, _firstDateForStatus.day).toString(),
                  "4 years" : DateTime(_firstDateForStatus.year+4, _firstDateForStatus.month, _firstDateForStatus.day).toString(),
                  "5 years" : DateTime(_firstDateForStatus.year+5, _firstDateForStatus.month, _firstDateForStatus.day).toString(),
                  "10 years" : DateTime(_firstDateForStatus.year+10, _firstDateForStatus.month, _firstDateForStatus.day).toString(),
                  "15 years" : DateTime(_firstDateForStatus.year+15, _firstDateForStatus.month, _firstDateForStatus.day).toString(),
                  "20 years" : DateTime(_firstDateForStatus.year+20, _firstDateForStatus.month, _firstDateForStatus.day).toString(),
                }
            );
          });
          Navigator.pop(context);
        },
        child: Text(
          'Save'
        ),
      ),
    );
  }
}
