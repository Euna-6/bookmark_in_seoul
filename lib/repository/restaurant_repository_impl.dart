import 'package:bookmark_in_seoul/data/sample_data.dart';

import 'restaurant_repository.dart';
import '../model/restaurant.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  @override
  List<Restaurant> fetchRestaurants() {
    return sampleData;
  }

}