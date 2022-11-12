import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app_submission_3/data/model/restaurant.dart';
import 'package:rxdart/subjects.dart';
import 'dart:convert';

import '../common/navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('food_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? "Empty payload");
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantResult restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "dicoding food";

    var androidPlatformChannelSpesifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpesifics = IOSNotificationDetails();
    var platformChannelSpesifics = NotificationDetails(
      android: androidPlatformChannelSpesifics,
      iOS: iOSPlatformChannelSpesifics,
    );

    Random random = Random();
    int randomNumber = random.nextInt(restaurant.restaurants.length);
    var titleNotification = "<b>Dicoding Restaurants</b>";
    var notificationTitle =
        "New restaurant, welcome <b>${restaurant.restaurants[randomNumber].name}</b>";

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, notificationTitle, platformChannelSpesifics,
        payload: json.encode(restaurant.toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = RestaurantResult.fromJson(json.decode(payload));
      var restaurant = data.restaurants[0].id;
      Navigation.intentWithData(route, restaurant);
    });
  }
}
