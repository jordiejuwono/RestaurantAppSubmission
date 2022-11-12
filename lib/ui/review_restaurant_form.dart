import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/provider/add_review_provider.dart';
import '../data/network/restaurantapi/api_service.dart';

class ReviewRestaurantForm extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  const ReviewRestaurantForm({
    Key? key,
    required this.restaurantId,
    required this.restaurantName,
  }) : super(key: key);

  @override
  State<ReviewRestaurantForm> createState() => _ReviewRestaurantFormState();
}

class _ReviewRestaurantFormState extends State<ReviewRestaurantForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  ApiService getApi = ApiService();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AddReviewProvider>(context, listen: false);
    Widget pageTitle() {
      return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        alignment: Alignment.topCenter,
        child: const Text(
          "Add Review",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 26.0,
          ),
        ),
      );
    }

    Widget nameField() {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8.0,
        ),
        child: TextField(
          controller: nameController,
          decoration: InputDecoration(
              hintText: "Input your name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              )),
        ),
      );
    }

    Widget reviewField() {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8.0,
        ),
        child: TextField(
          maxLines: 5,
          maxLength: 300,
          controller: reviewController,
          decoration: InputDecoration(
              hintText: "Type your review here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              )),
        ),
      );
    }

    Widget buttonPostReview() {
      return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(
          right: 20.0,
          top: 12.0,
        ),
        child: ElevatedButton(
          onPressed: () {
            if (nameController.text.trim() != "" &&
                reviewController.text.trim() != "") {
              provider.sendRestaurantReview(widget.restaurantId,
                  nameController.text, reviewController.text);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Fill all the fields first!")));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Send Review",
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.restaurantName,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            pageTitle(),
            nameField(),
            reviewField(),
            buttonPostReview(),
          ],
        ),
      ),
    );
  }
}
