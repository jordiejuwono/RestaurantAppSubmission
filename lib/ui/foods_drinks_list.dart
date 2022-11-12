import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/provider/add_review_provider.dart';

import '../data/model/restaurant_details.dart';

class FoodsDrinksList extends StatelessWidget {
  static const routeName = '/foods_drinks_list';
  final String type;
  final Restaurant restaurant;
  const FoodsDrinksList(
      {Key? key, required this.restaurant, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget foodsAndDrinksList() {
      return type == "Foods"
          ? ListView.builder(
              itemCount: restaurant.menus.foods.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(restaurant.menus.foods[index].name)));
                    },
                    title: Text(
                      restaurant.menus.foods[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ));
              },
            )
          : ListView.builder(
              itemCount: restaurant.menus.drinks.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(restaurant.menus.drinks[index].name)));
                  },
                  title: Text(
                    restaurant.menus.drinks[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${restaurant.name} $type',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: foodsAndDrinksList(),
    );
  }
}
