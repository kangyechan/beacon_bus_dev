import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Alarm {

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Alarm() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void onSelectNotification(String payload) {
    print(payload);
  }

  showNotification(int major, String stateAlarm) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await _flutterLocalNotificationsPlugin.show(
        major, '승하차 알림', stateAlarm, platform,
        payload: stateAlarm);
  }
}