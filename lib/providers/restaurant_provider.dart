import 'package:bookmark_in_seoul/model/restaurant.dart';
import 'package:bookmark_in_seoul/repository/restaurant_repository.dart';
import 'package:bookmark_in_seoul/repository/restaurant_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref){
  return RestaurantRepositoryImpl();
});

// 북마크 설정, 해제 기능과 관련된 기능들 모음
class RestaurantNofitier extends Notifier<List<Restaurant>> {

  @override
  List<Restaurant> build() {
    // 처음엔 빈 리스트로 보여주고 아래 함수에서 데이터를 비동기로 불러옴
    // build 안에서는 await를 쓸 수 없기 때문
    _loadInitialData();
    return [];

    // Repository를 가져와서 초기 데이터 설정
    // final repo = ref.read(restaurantRepositoryProvider);
    // return repo.fetchRestaurants();

    // 전체 데이터
    // return sampleData;
  }

  Future<void> _loadInitialData() async {
    final repo = ref.read(restaurantRepositoryProvider);
    state = await repo.fetchRestaurants();
  }

  // 북마크 상태 반전 기능
  Future<void> toggleBookmark(int id, int iconType) async {
    final repo = ref.read(restaurantRepositoryProvider);

    // 화면 업데이트
    /*
    state = [
      for (final res in state)
        if (res.id == id)
          // 설정된 아이콘을 또 눌렀다면 해제
          res.bookmark == iconType
            ? res.copyWith(
            isBookmarked: false,
            bookmark: 0,
            myMemo: " ",
          )
          : res.copyWith(
              isBookmarked: true,
              bookmark: iconType,
              updatedAt: DateTime.now(),
          )
        else
          res,
    ];
     */
    state = [
      for (final res in state)
        if (res.id==id) _handleToggle(res, iconType) else res,
    ];

    // DB 업데이트
    final updatedRes = state.firstWhere((res)=> res.id==id);
    await repo.addRestaurant(updatedRes);
  }

  // 북마크 상태 변경 관련 로직
  Restaurant _handleToggle(Restaurant res, int iconType){
    if(res.bookmark == iconType){
      // 같은 아이콘 눌렀을 때는 해제한다
      return _applyCountChange(res, iconType, -1).copyWith(
        isBookmarked : false,
        bookmark : 0,
        myMemo: " ",
        updatedAt: DateTime.now(),
      );
    } else {
      // 새 아이콘 눌렀을 때
      Restaurant temp = res;
      if(res.bookmark != 0){
        // 다른 아이콘이 설정 되어있는 상태라면 카운트를 1 차감한다
        temp = _applyCountChange(res, res.bookmark, -1);
      }
      return _applyCountChange(temp, iconType, 1).copyWith(
        isBookmarked : true,
        bookmark : iconType,
        updatedAt : DateTime.now(),
      );
    }
  }

  // _handleToggle에서 사용. 아이콘 종류에 따른 카운트 증감
  Restaurant _applyCountChange(Restaurant res, int type, int change){
    switch(type) {
      case 1 : return res.copyWith(cntStar: res.cntStar + change);
      case 2 : return res.copyWith(cntHeart: res.cntHeart + change);
      case 3 : return res.copyWith(cntCheck: res.cntCheck + change);
      case 4 : return res.copyWith(cntX: res.cntX + change);
      default : return res;
    }
  }
}

final restaurantProvider = NotifierProvider<RestaurantNofitier, List<Restaurant>> (
    () => RestaurantNofitier(),
);