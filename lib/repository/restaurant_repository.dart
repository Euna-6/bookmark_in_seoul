import '../model/restaurant.dart';

abstract class RestaurantRepository{
  // 식당 리스트를 가져옴
  // 서버 연동시에는 Future로 묶어주기
  List<Restaurant> fetchRestaurants();
}