import 'package:bookmark_in_seoul/data/district_data.dart';
import 'package:bookmark_in_seoul/model/restaurant.dart';
import 'package:bookmark_in_seoul/repository/restaurant_repository.dart';
import 'package:bookmark_in_seoul/repository/restaurant_repository_impl.dart';
import 'package:bookmark_in_seoul/service/kakao_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loading_provider.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref){
  return RestaurantRepositoryImpl();
});

// 북마크 설정, 해제와 관련된 기능들 모음
class RestaurantNofitier extends Notifier<List<Restaurant>> {

  @override
  List<Restaurant> build() {
    // 처음엔 빈 리스트로 보여주고 아래 함수에서 데이터를 비동기로 불러옴
    // build 안에서는 await를 쓸 수 없기 때문
    _loadInitialData();
    return [];
  }

  Future<void> _loadInitialData() async {
    final repo = ref.read(restaurantRepositoryProvider);

    // Firestore에 데이터가 있는지 확인
    final existing = await repo.fetchRestaurants();

    if(existing.isEmpty){
      print('Firestore 데이터 X. 카카오 API 호출 시작');
      // 로딩 시작
      ref.read(isLoadingProvider.notifier).start();

      final kakaoService = KakaoApiService();

      // 로딩 시간을 줄이기 위해 첫 지역 먼저 검색 후 화면 출력
      final firstDistrict = '영등포구'; // 이후에 수정
      final firstRestaurants = await kakaoService.searchRestaurants('$firstDistrict 음식점');
      print('[restaurant_provider] $firstDistrict 검색 완료: ${firstRestaurants.length}개');

      for (var restaurant in firstRestaurants){
        await repo.addRestaurant(restaurant);
      }

      state = await repo.fetchRestaurants();
      ref.read(isLoadingProvider.notifier).end();

      // 이후 나머지 24개 구를 백그라운드에서 검색 후 저장
      final remaining = districtNames.where((d)=> d['value'] != firstDistrict).toList();

      for (var district in remaining) {
        final value = district['value']!;
        final restaurants = await kakaoService.searchRestaurants('$value 음식점');
        for (var restaurant in restaurants) {
          await repo.addRestaurant(restaurant);
        }
      }

      state = await repo.fetchRestaurants();

    } else {
      state = existing;
    }
  }

  // 북마크 설정or해제 시에 카운트 업데이트
  Future<void> updateCount(String restaurantId, int iconType, int change) async {
    final repo = ref.read(restaurantRepositoryProvider);

    state = [
      for (final res in state)
        if (res.id == restaurantId)
          _applyCountChange(res, iconType, change)
        else res,
    ];

    // DB 업데이트
    final updatedRes = state.firstWhere((res) => res.id == restaurantId);
    await repo.addRestaurant(updatedRes);
  }



  // 아이콘 종류에 따른 카운트 증감
  Restaurant _applyCountChange(Restaurant res, int iconType, int change){
    switch(iconType) {
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