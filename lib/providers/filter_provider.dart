import 'package:bookmark_in_seoul/model/restaurant.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// my_bookmark에서 북마크별 보기 설정에 필요한 상태 관리
class FilterNotifier extends Notifier<Set<int>> {

  // 초깃값 설정. 얘가 state가 된다
  @override
  Set<int> build() {
    return {};
  }

  // 북마크 추가, 삭제 기능
  // .add 안씀. 통째로 갈아 끼워야 Flutter가 화면 다시 그려줌
  void toggle(int id){
    if (state.contains(id)) {
      // 현재 상태 복사해서 삭제
      state = {...state}..remove(id);
    } else {
      // 현재 상태 복사해서 추가
      state = {...state, id};
    }
  }
}

// 외부에서 호출할 수 있도록 하기 위함
final filterProvider = NotifierProvider<FilterNotifier, Set<int>>(
    () => FilterNotifier(),
);

// 필터링된 리스트를 제공하는 Provider
final filteredRestaurantProvider = Provider<List<Restaurant>> ((ref) {
   final iconType = ref.watch(filterProvider);

   // 북마크 전체 리스트
   final allBookmarked = ref.watch(restaurantProvider);
   // 북마크 설정된 리스트
   final bookmarkedList = allBookmarked.where((item)=> item.isBookmarked).toList();

   // 필터링 후에 아이템이 없으면 전체 리스트를 출력
   // 아이템이 있으면 필터링된 아이템 리스트를 출력
   if(iconType.isEmpty){
     return bookmarkedList;
   } else {
     return bookmarkedList
         .where((item) => iconType.contains(item.bookmark))
         .toList();
   }
});