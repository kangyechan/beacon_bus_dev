import 'package:intl/intl.dart';

class ParentDateHelpers {
  String getCurrentDate() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat.M().add_d().add_EEEE();
    String unFormattedTime = formatter.format(now).toString();
    return getFormattedDate(unFormattedTime);
  }

  String calculateFormattedDateMDE(DateTime time) {
    DateFormat formatter = DateFormat.M().add_d().add_EEEE();
    String unFormattedTime = formatter.format(time).toString();
    return getFormattedDate(unFormattedTime);
  }

  String calculateFormattedDateYMD(DateTime time) {
    DateFormat formatter = DateFormat.y().add_M().add_d().add_EEEE();
    String unFormattedTime = formatter.format(time);
    return getFormattedDate(unFormattedTime);
  }

  String changeForamtToGetOnlyDateAndDay(String unformattedDate) {
    return unformattedDate.split('')
        .reversed
        .join('')
        .substring(0, 5)
        .split('')
        .reversed
        .join('');
  }

  List<String> getOneWeekDate() {
    List<String> oneWeekDate = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      var newUnformattedTime = now.add(Duration(days: i));
      DateFormat formatter = DateFormat.y().add_M().add_d().add_EEEE();
      String unFormattedTime = formatter.format(newUnformattedTime).toString();
      oneWeekDate.add(getFormattedDate(unFormattedTime));
    }

    return oneWeekDate;
  }


  String getFormattedDate(String unFormattedTime) {
    List<String> split = unFormattedTime.split(" ");
    String result = "0월 0일";
    if (split.length == 3) {
      switch (split[2]) {
        case 'Monday':
          split[2] = '월';
          break;
        case 'Tuesday':
          split[2] = '화';
          break;
        case 'Wednesday':
          split[2] = '수';
          break;
        case 'Thursday':
          split[2] = '목';
          break;
        case 'Friday':
          split[2] = '금';
          break;
        case 'Saturday':
          split[2] = '토';
          break;
        case 'Sunday':
          split[2] = '일';
          break;
      }
      result = "${split[0]}월 ${split[1]}일 ${split[2]}요일";
    } else {
      switch (split[3]) {
        case 'Monday':
          split[3] = '월';
          break;
        case 'Tuesday':
          split[3] = '화';
          break;
        case 'Wednesday':
          split[3] = '수';
          break;
        case 'Thursday':
          split[3] = '목';
          break;
        case 'Friday':
          split[3] = '금';
          break;
        case 'Saturday':
          split[3] = '토';
          break;
        case 'Sunday':
          split[3] = '일';
          break;
      }
      result = "${split[0]}년 ${split[1]}월 ${split[2]}일 ${split[3]}요일";
    }
    return result;
  }
}