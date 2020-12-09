//code taken from 06a_Snackbars_and_Notifications Lecture Example. modified for this app and added deleteNotification function

import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class EventNotifications {
  final channelId = 'eventNotifications';
  final channelName = 'Event Notifications';
  final channelDescription = 'Event Notification Channel';

  var _flutterLocalNotificationsPlugin;

  NotificationDetails _platformChannelInfo;
  var _notificationId = 100;

  Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }

    var initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) {
        print('$id/$title/$body/$payload');
        return null;
      },
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    var androidChannelInfo = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ticker: 'ticker',
    );
    var iosChannelInfo = IOSNotificationDetails();

    _platformChannelInfo = NotificationDetails(
      android: androidChannelInfo,
      iOS: iosChannelInfo,
    );
  }

  _requestIOSPermission() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  Future onSelectNotification(var payload) async {
    if (payload != null) {
      print('onSelectNotification::payload = $payload');
    }
  }

  sendNotificationNow(String title, String body, String payload) {
    print(_flutterLocalNotificationsPlugin);
    _flutterLocalNotificationsPlugin.show(
      _notificationId++,
      title,
      body,
      _platformChannelInfo,
      payload: payload,
    );
  }

  sendNotificationLater(String title, String body, tz.TZDateTime when, String payload) {
    int id = _notificationId;
    _flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationId++,
      title,
      body,
      when,
      _platformChannelInfo,
      payload: payload,
      uiLocalNotificationDateInterpretation: null,
      androidAllowWhileIdle: true,
    );

    return id;
  }

  Future<List<PendingNotificationRequest>>
      getPendingNotificationRequests() async {
    return _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  deleteNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

}