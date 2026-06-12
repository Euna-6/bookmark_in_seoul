import 'package:bookmark_in_seoul/model/restaurant.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 지역별 필터링 상태 관리
class DistrictFilterNotifier extends Notifier<String?> {

  // 초기값 : 전체보기
  @override
  String? build() {
    return null;
  }

  void clear() {
    state = null;
  }

}

final districtFilterProvider = NotifierProvider<DistrictFilterNotifier, String?>(
      () => DistrictFilterNotifier(),
);

// 지역 필터만 적용된 리스트
final filteredDistrictProvider = Provider<List<Restaurant>> ((ref) {
  final selectedDistrict = ref.watch(districtFilterProvider); // 선택지역. 없으면 null
  final allRestaurants = ref.watch(restaurantProvider); // 전체 식당 리스트

  return selectedDistrict == null
      ? allRestaurants
      : allRestaurants
        .where((item)=> item.district == selectedDistrict)
        .toList();
});
