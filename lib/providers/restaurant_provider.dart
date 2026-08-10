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

  // 메모 변경 기능 : DetailRestaurant에서 사용
  Future<void> updateMemo(String id, String? memo) async {
    final repo = ref.read(restaurantRepositoryProvider);

    state = [
      for (final res in state)
        if (res.id == id)
          res.copyWith(
            myMemo: memo,
            clearMemo: memo == null,
          )
        else res,
    ];

    final updatedRes = state.firstWhere((res) => res.id == id);
    await repo.addRestaurant(updatedRes);
  }

  // 북마크 상태 반전 기능
  Future<void> toggleBookmark(String id, int iconType, String? memo) async {
    final repo = ref.read(restaurantRepositoryProvider);

    // 화면 업데이트
    state = [
      for (final res in state)
        if (res.id==id) _handleToggle(res, iconType, memo) else res,
    ];

    // DB 업데이트
    final updatedRes = state.firstWhere((res)=> res.id==id);
    await repo.addRestaurant(updatedRes);
  }

  // 북마크 상태 변경 관련 로직
  Restaurant _handleToggle(Restaurant res, int iconType, String? memo){
    if(res.bookmark == iconType){
      // 같은 아이콘 눌렀을 때는 해제한다
      return _applyCountChange(res, iconType, -1).copyWith(
        isBookmarked : false,
        bookmark : 0,
        clearMemo: true,
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
        myMemo: memo,
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