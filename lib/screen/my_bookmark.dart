import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:bookmark_in_seoul/providers/filter_provider.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../component/my_restaurant_item.dart';
import '../model/restaurant.dart';

class MyBookmark extends ConsumerStatefulWidget {
  MyBookmark({super.key});

  @override
  ConsumerState<MyBookmark> createState() => _MyBookmarkState();
}

class _MyBookmarkState extends ConsumerState<MyBookmark> {

  // 북마크 아이콘 선택 시에 '해제하시겠습니까' 팝업 띄우는 함수
  Future<void> unbookmark(WidgetRef ref, BuildContext context, Restaurant restaurant) async {
    bool? shouldRemove = await showDialog<bool>(
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

    // 사용자가 '해제'를 눌렀을 경우 실행
    if (shouldRemove == true) {
      ref.read(restaurantProvider.notifier).toggleBookmark(
        restaurant.id,
        restaurant.bookmark
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // 필터링된 리스트를 실시간으로 가져온다
    final filterList = ref.watch(filteredRestaurantProvider);

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
                ref.read(filterProvider.notifier).toggle(iconType);
              },
            ),
            // 하단 식당 목록
            Container(
              child: filterList.isEmpty
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
                      itemCount: filterList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = filterList[index];
                        return MyRestaurantItem(
                          restaurant: item,
                          onTap: () {
                            unbookmark(ref, context, item);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 16.0,
            )
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

// 상단 북마크별 필터 UI
class _FilterBookmark extends ConsumerWidget {
  final Function(int) onTap;

  const _FilterBookmark({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconType = ref.watch(filterProvider);

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
                            ref.read(filterProvider.notifier).toggle(1);
                          },
                        ),
                        BookmarkIcon(
                          bookmark: 2,
                          size: 45,
                          isBookmarked: iconType.contains(2),
                          onTap: () {
                            ref.read(filterProvider.notifier).toggle(2);
                          },
                        ),
                        BookmarkIcon(
                          bookmark: 3,
                          size: 45,
                          isBookmarked: iconType.contains(3),
                          onTap: () {
                            ref.read(filterProvider.notifier).toggle(3);
                          },
                        ),
                        BookmarkIcon(
                          bookmark: 4,
                          size: 45,
                          isBookmarked: iconType.contains(4),
                          onTap: () {
                            ref.read(filterProvider.notifier).toggle(4);
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
