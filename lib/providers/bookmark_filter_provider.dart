import 'package:bookmark_in_seoul/model/restaurant.dart';
import 'package:bookmark_in_seoul/providers/district_filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 북마크별 필터링 상태 관리
class BookmarkFilterNotifier extends Notifier<int?> {

  // 초깃값 설정. 얘가 state가 된다
  @override
  int? build() {
    return null;
  }

  void clear() {
    state = null;
  }

}

// 외부에서 호출할 수 있도록 하기 위함
final bookmarkFilterProvider = NotifierProvider<BookmarkFilterNotifier, int?>(
    () => BookmarkFilterNotifier(),
);

// 필터링된 리스트를 제공하는 Provider
final filteredBookmarkProvider = Provider<List<Restaurant>> ((ref) {
  final iconType = ref.watch(bookmarkFilterProvider);  // 선택 북마크. 없으면 null
  final districtFilter = ref.watch(filteredDistrictProvider);  // 지역 필터링 결과 갖고옴

  // 북마크 설정된 아이템 리스트
  final bookmarkedList = districtFilter
    .where((item)=> item.isBookmarked)
    .toList();

  // 지역별 필터링 결과에 북마크 필터를 추가 적용
  return iconType == null
      ? bookmarkedList
      : bookmarkedList
        .where((item)=>item.bookmark == iconType)
        .toList();

});


