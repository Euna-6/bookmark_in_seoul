import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:flutter/material.dart';
import '../component/my_restaurant_item.dart';
import '../model/restaurant.dart';
import '../data/sample_data.dart';

class MyBookmark extends StatefulWidget {
  MyBookmark({super.key});

  @override
  State<MyBookmark> createState() => _MyBookmarkState();
}

class _MyBookmarkState extends State<MyBookmark> {
  final List<Restaurant> bookmarkedList = sampleData
      .where((item) => item.bookmark > 0)
      .toList();
  late List<Restaurant>? filterList = bookmarkedList;
  Set<int> _iconType = {};

  // 북마크 아이콘 선택 시에 '해제하시겠습니까' 팝업 띄우는 함수
  Future<void> unbookmark(Restaurant restaurant) async {
    bool? shouldRemove = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("${restaurant.restaurantName}의 북마크를 해제하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("해제"),
          ),
        ],
      ),
    );

    if (shouldRemove == true) {
      setState(() {
        restaurant.isBookmarked = false;
        restaurant.bookmark = 0;
        restaurant.myMemo = null;
        bookmarkedList.remove(restaurant);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 최상단 로고 부분
            SizedBox(height: 15),
            Container(height: 100, width: 100, color: Colors.green),
            SizedBox(height: 15),
            // 상단 북마크별 보기 설정
            _FilterBookmark(
              onTap: (iconType) {
                filterList = bookmarkedList
                    .where((item) => item.bookmark == iconType)
                    .toList();
                setState(() {
                  // 선택된 아이콘을 또 누를 경우 취소시킨다
                  if (_iconType.contains(iconType)) {
                    _iconType.remove(iconType);
                  } else {
                    _iconType.add(iconType);
                  }
                  // _iconType에 따라 filterList를 업데이트한다
                  if (_iconType.isEmpty) {
                    filterList = bookmarkedList;
                  } else {
                    filterList = bookmarkedList
                        .where((item) => _iconType.contains(item.bookmark))
                        .toList();
                  }
                });
              },
              iconType: _iconType,
            ),
            // 하단 식당 목록
            Container(
              child: (filterList == null || filterList!.isEmpty)
                  ? Center(child: Text("리스트가 비었어요"))
                  : Expanded(
                      // 리스트의 아이템이 1개라도 있을때
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 16.0,
                        ),
                        child: Container(
                          color: const Color(0xFFEAEAEA),
                          child: ListView.builder(
                            itemCount: filterList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = filterList![index];
                              return MyRestaurantItem(
                                restaurant: item,
                                onTap: () => unbookmark(item),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

// 북마크별 필터 UI
class _FilterBookmark extends StatelessWidget {
  final Function(int) onTap;
  final Set<int> iconType;

  const _FilterBookmark({
    super.key,
    required this.onTap,
    required this.iconType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BookmarkIcon(
                          bookmark: 1,
                          size: 45,
                          isBookmarked: iconType.contains(1),
                          onTap: () {
                            onTap(1);
                          },
                        ),
                        BookmarkIcon(
                          bookmark: 2,
                          size: 45,
                          isBookmarked: iconType.contains(2),
                          onTap: () {
                            onTap(2);
                          },
                        ),
                        BookmarkIcon(
                          bookmark: 3,
                          size: 45,
                          isBookmarked: iconType.contains(3),
                          onTap: () {
                            onTap(3);
                          },
                        ),
                        BookmarkIcon(
                          bookmark: 4,
                          size: 45,
                          isBookmarked: iconType.contains(4),
                          onTap: () {
                            onTap(4);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
