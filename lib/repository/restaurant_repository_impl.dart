import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/menu.dart';
import 'restaurant_repository.dart';
import '../model/restaurant.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<Restaurant>> fetchRestaurants() async {
    // restaurants 컬렉션 전체 가져오기
    final snapshot = await _db.collection('restaurants').get();

    List<Restaurant> result = [];

    for (var doc in snapshot.docs) {
      // 각 식당의 menuList(서브컬렉션) 가졍괴
      final menuSnapshot = await _db
          .collection('restaurants')
          .doc(doc.id)
          .collection('menuList')
          .get();

      final menuList = menuSnapshot.docs
          .map((m) => Menu.fromMap(m.data(), id: m.id))
          .toList();

      result.add(Restaurant.fromMap(doc.data(), menuList, id: doc.id));
    }

    return result;
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