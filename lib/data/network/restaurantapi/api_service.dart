import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_submission_3/data/model/restaurant.dart';
import 'package:restaurant_app_submission_3/data/model/restaurant_details.dart';
import 'package:restaurant_app_submission_3/data/model/restaurant_search_model.dart';
import 'package:restaurant_app_submission_3/data/model/send_review.dart';

class ApiService {
  //GET Restaurant List
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _endPointList = 'list';
  static const String _endPointDetails = 'detail/';
  static const String _endPointSearch = 'search?q=';
  static const String _postReview = 'review';

  Future<RestaurantResult> getAllRestaurantList() async {
    final response = await http.get(Uri.parse(_baseUrl + _endPointList));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error in getting restaurant list');
    }
  }

  Future<RestaurantDetails> getRestaurantDetails(String restaurantId) async {
    final response =
        await http.get(Uri.parse(_baseUrl + _endPointDetails + restaurantId));
    if (response.statusCode == 200) {
      return RestaurantDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error getting restaurant details');
    }
  }

  Future<RestaurantSearchModel> getSearchedRestaurant(String query) async {
    final response =
        await http.get(Uri.parse(_baseUrl + _endPointSearch + query));
    if (response.statusCode == 200) {
      return RestaurantSearchModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('No Restaurant Found');
    }
  }

  Future<SendReview> sendRestaurantReview(
    String id,
    String name,
    String review,
  ) async {
    final response = await http.post(Uri.parse(_baseUrl + _postReview), body: {
      "id": id,
      "name": name,
      "review": review,
    });
    if (response.statusCode == 201) {
      return SendReview.fromJson(json.decode(response.body));
    } else {
      throw Exception('Review Failed');
    }
  }
}
