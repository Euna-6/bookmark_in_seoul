import '../model/restaurant.dart';

abstract class RestaurantRepository{
  Future<List<Restaurant>> fetchRestaurants();
  Future<void> addRestaurant(Restaurant restaurant);
  Future<void> removeRestaurant(String id);
}

/*
restaurant_repository와 restaurant_repository_impl의 관계

restaurant_repository : 식당 데이터를 가져오고, 저장하고, 삭제할 수 있는 규칙 (abstract)
restaurant_repository_impl : 규칙의 실제 구현
 */