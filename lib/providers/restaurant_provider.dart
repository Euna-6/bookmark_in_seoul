import 'package:bookmark_in_seoul/data/sample_data.dart';
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
    // Repository를 가져와서 초기 데이터 설정
    final repo = ref.read(restaurantRepositoryProvider);
    return repo.fetchRestaurants();

    // 전체 데이터
    // return sampleData;
  }

  // 북마크 상태 반전 기능
  void toggleBookmark(int id, int iconType){
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
          )
        else
          res,
    ];
  }
}

final restaurantProvider = NotifierProvider<RestaurantNofitier, List<Restaurant>> (
    () => RestaurantNofitier(),
);