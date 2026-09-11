import 'package:bookmark_in_seoul/model/user_bookmark.dart';
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

  // 유저 북마크 목록 가져오기
  @override
  Future<List<UserBookmark>> fetchUserBookmark(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .get();

    return snapshot.docs.map((doc) =>
        UserBookmark.fromMap(doc.data())
    ).toList();
  }

  // 북마크 저장 및 수정
  @override
  Future<void> setUserBookmark(String userId, UserBookmark bookmark) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(bookmark.restaurantId) // 식당 ID를 문서 ID로 사용
        .set(bookmark.toMap());
  }

  // 북마크 삭제
  @override
  Future<void> removeUserBookmark(String userId, String restaurantId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(restaurantId)
        .delete();
  }

}