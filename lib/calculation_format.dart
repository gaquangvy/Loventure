String getHoroscope(DateTime birthday) {
  switch (birthday.month) {
    case 1: return (birthday.day < 21) ? "Capricorn" : "Aquarius";
    case 2: return (birthday.day < 19) ? "Aquarius" : "Pisces";
    case 3: return (birthday.day < 21) ? "Pisces" : "Aries";
    case 4: return (birthday.day < 21) ? "Aries" : "Taurus";
    case 5: return (birthday.day < 22) ? "Taurus" : "Gemini";
    case 6: return (birthday.day < 22) ? "Gemini" : "Cancer";
    case 7: return (birthday.day < 23) ? "Cancer" : "Leo";
    case 8: return (birthday.day < 24) ? "Leo" : "Virgo";
    case 9: return (birthday.day < 23) ? "Virgo" : "Libra";
    case 10: return (birthday.day < 24) ? "Libra" : "Scorpio";
    case 11: return (birthday.day < 23) ? "Scorpio" : "Sagittarius";
    case 12: return (birthday.day < 22) ? "Sagittarius" : "Capricorn";
  }
  return "None";
}

int getAge(DateTime birthday) {
  DateTime current = DateTime.now();
  int age = current.year - birthday.year;
  if (birthday.month > current.month) {
    age--;
  } else if (birthday.month == current.month) {
    if (birthday.day > current.day) {
      age--;
    }
  }
  return age;
}

class Person {
  String profile = "https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png";
  String nickname;
  String horoscope;
  DateTime birthday;
  String gender;

  Person({this.birthday, this.gender, this.nickname, this.profile, this.horoscope});
}

String howManyDays(int dayNum) {
  return dayNum.toString() + ((dayNum > 1) ? " Days" : " Day") + " in Love";
}

double heartSize(int dayNum) {
  return (dayNum > 50) ? 200.0 : (150+dayNum)*1.0;
}