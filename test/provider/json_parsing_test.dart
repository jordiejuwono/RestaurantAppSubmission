import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app_submission_3/data/model/restaurant.dart';
import 'package:restaurant_app_submission_3/provider/restaurant_list_provider.dart';

void main() {
  //arrange
  var meltingPotData = {
    "id": "rqdv5juczeskfw1e867",
    "name": "Melting Pot",
    "description":
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
    "pictureId": "14",
    "city": "Medan",
    "rating": 4.2
  };
  test('should return restaurant id', () {
    //assert
    var result = Restaurant.fromJson(meltingPotData).id;
    expect(result, "rqdv5juczeskfw1e867");
  });
  test('should return restaurant name', () {
    //assert
    var result = Restaurant.fromJson(meltingPotData).name;
    expect(result, "Melting Pot");
  });
  test('should return restaurant city', () {
    //assert
    var result = Restaurant.fromJson(meltingPotData).city;
    expect(result, "Medan");
  });
}
