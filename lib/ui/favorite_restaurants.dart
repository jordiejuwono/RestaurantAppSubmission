import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/enum/results_state.dart';
import 'package:restaurant_app_submission_3/provider/database_provider.dart';
import 'package:restaurant_app_submission_3/widgets/restaurant_tile.dart';

class FavoriteRestaurants extends StatefulWidget {
  const FavoriteRestaurants({Key? key}) : super(key: key);

  @override
  State<FavoriteRestaurants> createState() => _FavoriteRestaurantsState();
}

class _FavoriteRestaurantsState extends State<FavoriteRestaurants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DatabaseProvider>(
        builder: (context, value, child) {
          if (value.state == ResultState.NoData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 80.0,
                    color: Colors.grey,
                  ),
                  Text(
                    "No Favorite\nRestaurant Yet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 26.0,
                    ),
                  ),
                ],
              ),
            );
          } else if (value.state == ResultState.NoData ||
              value.state == ResultState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: value.favorites.length,
            itemBuilder: (context, index) {
              return RestaurantTile(
                imageUrl: value.favorites[index].pictureId,
                restaurantLocation: value.favorites[index].city,
                restaurantRating: value.favorites[index].rating.toString(),
                restaurantTitle: value.favorites[index].name,
                restaurantId: value.favorites[index].id,
              );
            },
          );
        },
      ),
    );
  }
}
