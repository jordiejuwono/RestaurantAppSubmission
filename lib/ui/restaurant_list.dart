import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/provider/connectivity_provider.dart';
import 'package:restaurant_app_submission_3/provider/restaurant_details_provider.dart';
import 'package:restaurant_app_submission_3/provider/restaurant_list_provider.dart';
import 'package:restaurant_app_submission_3/ui/restaurant_details.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({Key? key}) : super(key: key);

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  @override
  void initState() {
    super.initState();
    final connectivity =
        Provider.of<ConnectivityProvider>(context, listen: false);
    final restaurantList =
        Provider.of<RestaurantListProvider>(context, listen: false);

    connectivity.startMonitoring();
    if (connectivity.isOnline != false) {
      restaurantList.getRestaurantList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantList = Provider.of<RestaurantListProvider>(context);

    Widget restaurantTitle() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              top: 5.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Restaurant List',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Recommended restaurants for you',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget showRestaurantList() {
      return Consumer<ConnectivityProvider>(builder: (context, value, child) {
        if (value.isOnline != false) {
          return restaurantList.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: restaurantList.restaurantList?.restaurants.length,
                  itemBuilder: (context, index) {
                    var pictureId = restaurantList
                        .restaurantList?.restaurants[index].pictureId;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 8.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChangeNotifierProvider(
                              create: (_) => RestaurantDetailsProvider(),
                              child: RestaurantDetails(
                                  restaurantId: restaurantList
                                          .restaurantList?.restaurants[index].id
                                          .toString() ??
                                      ""),
                            );
                          }));
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                            child: Image.network(
                              "https://restaurant-api.dicoding.dev/images/small/$pictureId",
                              fit: BoxFit.cover,
                              width: 100,
                            ),
                          ),
                          title: Text(restaurantList
                                  .restaurantList?.restaurants[index].name ??
                              ""),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 3.0,
                              ),
                              Text(restaurantList.restaurantList
                                      ?.restaurants[index].city ??
                                  ""),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  Text(
                                    restaurantList.restaurantList
                                            ?.restaurants[index].rating
                                            .toString() ??
                                        "",
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
        body: SafeArea(
      child: Column(
        children: [
          restaurantTitle(),
          Flexible(child: showRestaurantList()),
        ],
      ),
    ));
  }
}
