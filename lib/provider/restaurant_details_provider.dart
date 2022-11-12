import 'package:flutter/material.dart';
import 'package:restaurant_app_submission_3/data/model/restaurant_details.dart';
import '../data/network/restaurantapi/api_service.dart';

class RestaurantDetailsProvider extends ChangeNotifier {
  RestaurantDetails? restaurantDetails;
  ApiService getApi = ApiService();
  bool loading = false;

  getRestaurantDetails(String restaurantId) async {
    loading = true;
    restaurantDetails = await getApi.getRestaurantDetails(restaurantId);
    loading = false;

    notifyListeners();
  }
}
