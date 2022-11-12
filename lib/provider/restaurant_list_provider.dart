import 'package:flutter/material.dart';
import '../data/model/restaurant.dart';
import '../data/network/restaurantapi/api_service.dart';

class RestaurantListProvider extends ChangeNotifier {
  RestaurantResult? restaurantList;
  ApiService getApi = ApiService();
  bool loading = false;

  getRestaurantList() async {
    loading = true;
    print('loading...');
    print('getting data...');
    restaurantList = await getApi.getAllRestaurantList();
    print('get data done...');
    loading = false;

    notifyListeners();
  }
}
