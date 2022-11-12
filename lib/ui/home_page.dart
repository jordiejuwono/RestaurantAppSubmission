import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/data/local/db/database_helper.dart';
import 'package:restaurant_app_submission_3/data/preferences/preferences_helper.dart';
import 'package:restaurant_app_submission_3/provider/database_provider.dart';
import 'package:restaurant_app_submission_3/provider/preferences_provider.dart';
import 'package:restaurant_app_submission_3/provider/restaurant_search_provider.dart';
import 'package:restaurant_app_submission_3/ui/favorite_restaurants.dart';
import 'package:restaurant_app_submission_3/ui/restaurant_details.dart';
import 'package:restaurant_app_submission_3/ui/restaurant_list.dart';
import 'package:restaurant_app_submission_3/ui/restaurant_search.dart';
import 'package:restaurant_app_submission_3/ui/settings_page.dart';
import 'package:restaurant_app_submission_3/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _bottomNavIndex = 0;
  List<BottomNavigationBarItem> _bottomNavBarItem = [
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: 'Restaurant',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      label: 'Favorite',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  List<Widget> _listWidget = [
    RestaurantList(),
    ChangeNotifierProvider(
        create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        child: FavoriteRestaurants()),
    ChangeNotifierProvider(
        create: (_) => RestaurantSearchProvider(), child: RestaurantSearch()),
    ChangeNotifierProvider(
        create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance())),
        child: SettingsPage()),
  ];

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetails.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          items: _bottomNavBarItem,
          onTap: (selectedIndex) {
            setState(() {
              _bottomNavIndex = selectedIndex;
            });
          },
        ),
        body: _listWidget[_bottomNavIndex]);
  }
}
