import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/common/navigation.dart';
import 'package:restaurant_app_submission_3/data/local/db/database_helper.dart';
import 'package:restaurant_app_submission_3/provider/connectivity_provider.dart';
import 'package:restaurant_app_submission_3/provider/database_provider.dart';
import 'package:restaurant_app_submission_3/provider/restaurant_details_provider.dart';
import 'package:restaurant_app_submission_3/provider/scheduling_provider.dart';
import 'package:restaurant_app_submission_3/ui/restaurant_details.dart';
import 'package:restaurant_app_submission_3/ui/splash_screen.dart';
import 'package:restaurant_app_submission_3/utils/background_service.dart';
import 'package:restaurant_app_submission_3/utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate;
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                DatabaseProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider(create: (_) => RestaurantDetailsProvider()),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
            ),
          ),
          title: 'Restaurant App',
          home: SplashScreen(),
          navigatorKey: navigatorKey,
          routes: {
            RestaurantDetails.routeName: (context) => RestaurantDetails(
                restaurantId:
                    ModalRoute.of(context)?.settings.arguments as String),
          }),
    );
  }
}
