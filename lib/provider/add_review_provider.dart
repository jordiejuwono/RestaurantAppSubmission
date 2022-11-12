import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_submission_3/data/model/send_review.dart';

import '../data/network/restaurantapi/api_service.dart';

class AddReviewProvider extends ChangeNotifier {
  SendReview? sendReview;
  ApiService getApi = ApiService();

  sendRestaurantReview(String id, String name, String review) async {
    sendReview = await getApi.sendRestaurantReview(id, name, review);
  }
}
