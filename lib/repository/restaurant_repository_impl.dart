import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/menu.dart';
import 'restaurant_repository.dart';
import '../model/restaurant.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // Firestore에서 전체 식당 데이터를 가져와 List<Restaurant>으로 반환
  @override
  Future<List<Restaurant>> fetchRestaurants() async {
    // restaurants 컬렉션 전체 가져오기
    final snapshot = await _db.collection('restaurants').get();

    return snapshot.docs.map((doc) =>
        Restaurant.fromMap(doc.data(), [], id: doc.id)
    ).toList();
  }

  Future<List<Menu>> fetchMenu(String restaurantId) async {
    final menuSnapshot = await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuList')
        .get();

    return menuSnapshot.docs
        .map((m) => Menu.fromMap(m.data(), id:m.id))
        .toList();
  }

  @override
  Future<void> addRestaurant(Restaurant restaurant) async {
    // 식당 정보 저장
    await _db
        .collection('restaurants')
        .doc(restaurant.id)
        .set(restaurant.toMap());

    // 메뉴 정보 저장
    for (var menu in restaurant.menuList ?? []){
      await _db
          .collection('restaurants')
          .doc(restaurant.id)
          .collection('menuList')
          .doc(menu.id)
          .set(menu.toMap(restaurant.id));
    }
  }

  @override
  Future<void> removeRestaurant(String id) async {
    await _db.collection('restaurants').doc(id).delete();
  }

}