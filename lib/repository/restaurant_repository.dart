import '../database/database_helper.dart';
import '../model/restaurant.dart';

abstract class RestaurantRepository{
  // 식당 리스트를 가져옴
  // List<Restaurant> fetchRestaurants();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Restaurant>> fetchRestaurants() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> resMaps = await db.query(
      'restaurants',
      orderBy: 'updatedAt DESC'
    );

    return await _dbHelper.getAllRestaurants();
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    await _dbHelper.insertRestaurant(restaurant);
  }

  Future<void> removeRestaurant(int id) async {
    await _dbHelper.deleteRestaurant(id);
  }
}