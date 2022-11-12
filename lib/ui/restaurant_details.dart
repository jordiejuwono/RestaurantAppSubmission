import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/data/local/db/database_helper.dart';
import 'package:restaurant_app_submission_3/data/model/restaurant.dart';
import 'package:restaurant_app_submission_3/provider/add_review_provider.dart';
import 'package:restaurant_app_submission_3/provider/connectivity_provider.dart';
import 'package:restaurant_app_submission_3/provider/database_provider.dart';
import 'package:restaurant_app_submission_3/provider/restaurant_details_provider.dart';
import 'package:restaurant_app_submission_3/ui/review_restaurant_form.dart';

import 'foods_drinks_list.dart';

class RestaurantDetails extends StatefulWidget {
  static const routeName = "/details";
  final String restaurantId;
  const RestaurantDetails({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  @override
  void initState() {
    var provider =
        Provider.of<RestaurantDetailsProvider>(context, listen: false);
    provider.getRestaurantDetails(widget.restaurantId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refreshPage() {
      var connectivity =
          Provider.of<ConnectivityProvider>(context, listen: false);
      var provider =
          Provider.of<RestaurantDetailsProvider>(context, listen: false);
      connectivity.startMonitoring();
      if (connectivity.isOnline != false) {
        provider.getRestaurantDetails(widget.restaurantId);
      }
    }

    Widget restaurantDetails() {
      return Consumer<ConnectivityProvider>(builder: (context, value, child) {
        if (value.isOnline != null) {
          var provider = Provider.of<RestaurantDetailsProvider>(context);
          if (provider.restaurantDetails != null) {
            var pictureId = provider.restaurantDetails?.restaurant.pictureId;
            return provider.loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://restaurant-api.dicoding.dev/images/small/$pictureId"),
                                    fit: BoxFit.cover)),
                          ),
                          SafeArea(
                            child: Container(
                              margin: EdgeInsets.all(
                                12.0,
                              ),
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Consumer<DatabaseProvider>(
                                    builder: (context, value, child) {
                                      return FutureBuilder(
                                          future: value
                                              .isFavorited(widget.restaurantId),
                                          builder: (context, snapshot) {
                                            var isFavorited =
                                                snapshot.data ?? false;
                                            return GestureDetector(
                                                child: isFavorited == true
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                onTap: () {
                                                  isFavorited == true
                                                      ? showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Delete from Favorite"),
                                                              content: Text(
                                                                  "Do you want to remove this restaurant from favorites?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "No"),
                                                                ),
                                                                ChangeNotifierProvider(
                                                                  create: (_) =>
                                                                      DatabaseProvider(
                                                                          databaseHelper:
                                                                              DatabaseHelper()),
                                                                  child:
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            var database =
                                                                                Provider.of<DatabaseProvider>(context, listen: false);
                                                                            database.removeFavorite(widget.restaurantId);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text("Yes")),
                                                                )
                                                              ],
                                                            );
                                                          })
                                                      : showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Save to Favorite"),
                                                              content: Text(
                                                                  "Do you want to save this restaurant to favorites?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "No"),
                                                                ),
                                                                ChangeNotifierProvider(
                                                                  create: (_) =>
                                                                      DatabaseProvider(
                                                                          databaseHelper:
                                                                              DatabaseHelper()),
                                                                  child:
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            var database =
                                                                                Provider.of<DatabaseProvider>(context, listen: false);
                                                                            var restaurant = Restaurant(
                                                                                id: provider.restaurantDetails?.restaurant.id ?? "",
                                                                                name: provider.restaurantDetails?.restaurant.name ?? "",
                                                                                description: provider.restaurantDetails?.restaurant.description ?? "",
                                                                                pictureId: provider.restaurantDetails?.restaurant.pictureId ?? "",
                                                                                city: provider.restaurantDetails?.restaurant.city ?? "",
                                                                                rating: provider.restaurantDetails?.restaurant.rating ?? 0.0);
                                                                            database.addFavorite(restaurant);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text("Yes")),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                });
                                          });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.restaurantDetails!.restaurant.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 30.0,
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              provider.restaurantDetails!.restaurant.city,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Text(
                                  provider.restaurantDetails!.restaurant.rating
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Wrap(
                              children: [
                                ...provider
                                    .restaurantDetails!.restaurant.categories
                                    .map((e) => Container(
                                        margin: EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16.0,
                                          ),
                                          border: Border.all(
                                              width: 1, color: Colors.black),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 8.0,
                                        ),
                                        child: Text(
                                          e.name,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        )))
                              ],
                            ),
                            SizedBox(
                              height: 22.0,
                            ),
                            Text(
                              "Description",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 26.0,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              provider
                                  .restaurantDetails!.restaurant.description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 22.0,
                            ),
                            Text(
                              "Foods & Drinks",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 26.0,
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16.0, right: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return FoodsDrinksList(
                                                restaurant: provider
                                                    .restaurantDetails!
                                                    .restaurant,
                                                type: 'Foods');
                                          },
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.orange,
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/image_foods_logo.png',
                                              width: 100,
                                              height: 80,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 6.0,
                                            left: 6.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Foods",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              Text(
                                                "${provider.restaurantDetails?.restaurant.menus.foods.length} menus",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return FoodsDrinksList(
                                                restaurant: provider
                                                    .restaurantDetails!
                                                    .restaurant,
                                                type: 'Drinks');
                                          },
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.orange,
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/image_drinks_logo.png',
                                              width: 100,
                                              height: 70,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 6.0, bottom: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Drinks",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              Text(
                                                "${provider.restaurantDetails?.restaurant.menus.drinks.length} menus",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reviews",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26.0,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 8.0,
                                    top: 8.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChangeNotifierProvider(
                                          create: (_) => AddReviewProvider(),
                                          child: ReviewRestaurantForm(
                                            restaurantId: provider
                                                .restaurantDetails!
                                                .restaurant
                                                .id,
                                            restaurantName: provider
                                                .restaurantDetails!
                                                .restaurant
                                                .name,
                                          ),
                                        );
                                      })).then((value) => refreshPage());
                                    },
                                    child: Text(
                                      "Add Review",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 3.0,
                                vertical: 8.0,
                              ),
                              child: Consumer<RestaurantDetailsProvider>(
                                builder: (context, value, child) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...value.restaurantDetails!.restaurant
                                          .customerReviews
                                          .map((e) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            bottom: 20.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.0,
                                              ),
                                              Text(
                                                e.date,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6.0,
                                              ),
                                              Text(
                                                e.review,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          } else {
            return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 300.0,
                ),
                child: CircularProgressIndicator());
          }
        } else {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.error,
                  size: 50.0,
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  "No Connection Detected,\nPlease Check Your Connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          );
        }
      });
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: restaurantDetails(),
      ),
    ));
  }
}
