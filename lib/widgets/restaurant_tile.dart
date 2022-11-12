import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/provider/database_provider.dart';
import 'package:restaurant_app_submission_3/provider/restaurant_details_provider.dart';
import 'package:restaurant_app_submission_3/ui/restaurant_details.dart';

class RestaurantTile extends StatefulWidget {
  final String imageUrl;
  final String restaurantTitle;
  final String restaurantRating;
  final String restaurantLocation;
  final String restaurantId;
  const RestaurantTile(
      {Key? key,
      required this.imageUrl,
      required this.restaurantLocation,
      required this.restaurantRating,
      required this.restaurantTitle,
      required this.restaurantId})
      : super(key: key);

  @override
  State<RestaurantTile> createState() => _RestaurantTileState();
}

class _RestaurantTileState extends State<RestaurantTile> {
  void refreshPage() {
    setState(() {
      var provider = Provider.of<DatabaseProvider>(context, listen: false);
      provider.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChangeNotifierProvider(
              create: (_) => RestaurantDetailsProvider(),
              child: RestaurantDetails(restaurantId: widget.restaurantId));
        })).then((value) => refreshPage());
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/small/${widget.imageUrl}",
                  fit: BoxFit.cover,
                  width: 100,
                  height: 80,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.restaurantTitle,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.0),
                Text(
                  widget.restaurantLocation,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(widget.restaurantRating),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
