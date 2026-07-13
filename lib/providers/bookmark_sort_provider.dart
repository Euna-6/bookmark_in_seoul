import 'package:bookmark_in_seoul/model/restaurant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'district_filter_provider.dart';

// 북마크별 정렬 상태 관리
class BookmarkSortNotifier extends Notifier<int?>{

  int? build() {
    return null;
  }

  void clear() {
    state = null;
  }
}

final bookmarkSortProvider = NotifierProvider<BookmarkSortNotifier, int?>(
    ()=>BookmarkSortNotifier(),
);

int _getType(Restaurant item, int type){
  switch(type){
    case 1: return item.cntStar;
    case 2: return item.cntHeart;
    case 3: return item.cntCheck;
    case 4: return item.cntX;
    default: return 0;
  }
}

final sortedBookmarkProvider = Provider<List<Restaurant>> ((ref) {
  final iconType = ref.watch(bookmarkSortProvider);  // 선택 북마크. 없으면 null
  final districtFilter = ref.watch(filteredDistrictProvider);  // 지역 필터링 결과 갖고옴

  if (iconType == null){
    return districtFilter;
  }

  // 북마크 갯수가 많은 순으로 정렬(내림차순)
  final sortedList = [...districtFilter]
    ..sort((a, b) => _getType(b, iconType)
      .compareTo(_getType(a, iconType)));

  return sortedList;
});
