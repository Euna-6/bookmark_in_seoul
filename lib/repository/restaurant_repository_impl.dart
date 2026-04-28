import 'package:bookmark_in_seoul/data/sample_data.dart';
import 'package:bookmark_in_seoul/database/database_helper.dart';
import 'restaurant_repository.dart';
import '../model/restaurant.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Restaurant>> fetchRestaurants() async {
    return await _dbHelper.getAllRestaurants();
  }

  @override
  Future<void> addRestaurant(Restaurant restaurant) async {
    await _dbHelper.insertRestaurant(restaurant);
  }

  @override
  Future<void> removeRestaurant(int id) async {
    await _dbHelper.deleteRestaurant(id);
  }

}