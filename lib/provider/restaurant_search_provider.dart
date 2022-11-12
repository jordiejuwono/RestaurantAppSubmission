import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_submission_3/data/model/restaurant_search_model.dart';
import '../data/network/restaurantapi/api_service.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  RestaurantSearchModel? restaurantSearchModel;
  ApiService getApi = ApiService();
  bool loading = false;

  getSearchedRestaurants(String query) async {
    loading = true;
    restaurantSearchModel = await getApi.getSearchedRestaurant(query);
    loading = false;

    notifyListeners();
  }
}
