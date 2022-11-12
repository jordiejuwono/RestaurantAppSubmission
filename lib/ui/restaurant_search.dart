import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/provider/connectivity_provider.dart';
import 'package:restaurant_app_submission_3/provider/restaurant_search_provider.dart';
import 'package:restaurant_app_submission_3/ui/restaurant_details.dart';
import 'package:restaurant_app_submission_3/widgets/restaurant_tile.dart';

class RestaurantSearch extends StatefulWidget {
  const RestaurantSearch({Key? key}) : super(key: key);

  @override
  State<RestaurantSearch> createState() => _RestaurantSearchState();
}

class _RestaurantSearchState extends State<RestaurantSearch> {
  var query = '';
  final editingController = TextEditingController();

  @override
  void initState() {
    var connectivity =
        Provider.of<ConnectivityProvider>(context, listen: false);
    var provider =
        Provider.of<RestaurantSearchProvider>(context, listen: false);
    connectivity.startMonitoring();
    provider.getSearchedRestaurants(query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RestaurantSearchProvider>(context);
    Widget searchField() {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        width: double.infinity,
        child: TextField(
          controller: editingController,
          onSubmitted: (value) {
            setState(() {
              query = value;
              Provider.of<RestaurantSearchProvider>(context, listen: false)
                  .getSearchedRestaurants(value);
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
              ),
              hintText: "Search for Restaurant",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                8.0,
              ))),
        ),
      );
    }

    Widget searchedRestaurantList() {
      return Consumer<ConnectivityProvider>(builder: (context, value, child) {
        if (value.isOnline != false) {
          if (query == '') {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 120.0,
                      color: Colors.grey,
                    ),
                    Text(
                      "Search for Restaurants",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (provider.restaurantSearchModel?.founded == 0) {
            return Expanded(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.question_mark,
                    color: Colors.grey,
                    size: 120.0,
                  ),
                  Text(
                    "No Results Found",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ));
          }
          if (provider.restaurantSearchModel != null) {
            return Expanded(
              child: ListView.builder(
                  itemCount: provider.restaurantSearchModel!.restaurants.length,
                  itemBuilder: (context, index) {
                    var pictureId = provider
                        .restaurantSearchModel!.restaurants[index].pictureId;
                    return RestaurantTile(
                      imageUrl: pictureId,
                      restaurantLocation: provider
                          .restaurantSearchModel!.restaurants[index].city,
                      restaurantRating: provider
                          .restaurantSearchModel!.restaurants[index].rating
                          .toString(),
                      restaurantTitle: provider
                          .restaurantSearchModel!.restaurants[index].name,
                      restaurantId:
                          provider.restaurantSearchModel!.restaurants[index].id,
                    );
                  }),
            );
          } else {
            return Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        } else {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          );
        }
      });
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            searchField(),
            searchedRestaurantList(),
          ],
        ),
      ),
    );
  }
}
