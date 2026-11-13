import 'package:bookmark_in_seoul/component/isbookmark_dialog.dart';
import 'package:bookmark_in_seoul/component/filter_box.dart';
import 'package:bookmark_in_seoul/providers/bookmark_filter_provider.dart';
import 'package:bookmark_in_seoul/providers/district_filter_provider.dart';
import 'package:bookmark_in_seoul/providers/user_bookmark_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../component/my_restaurant_item.dart';

class MyBookmark extends ConsumerStatefulWidget {
  MyBookmark({super.key});

  @override
  ConsumerState<MyBookmark> createState() => _MyBookmarkState();
}

class _MyBookmarkState extends ConsumerState<MyBookmark> {

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      ref.read(districtFilterProvider.notifier).clear();
      ref.read(bookmarkFilterProvider.notifier).clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 필터링된 리스트를 실시간으로 가져온다
    final filterList = ref.watch(filteredBookmarkProvider);
    final userBookmarks = ref.watch(userBookmarkProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 최상단 로고 부분
            SizedBox(height: 15),
            Image.asset(
              'assets/icon/icon.png',
              width: 70,
              height: 70,
            ),
            Divider(
              height:20,
              color: Color(0xFED6D6D6),
            ),
            // 상단 북마크별 보기 설정
            SizedBox(
                height: 86,
                child: FilterBox(mode: FilterMode.filter)
            ),
            // 하단 식당 목록
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0, right:16.0, top: 8.0,
                ),
                child: Container(
                  child: filterList.isEmpty
                      ? Column(
                        children: [
                          SizedBox(height:180),
                          Image.asset(
                            'assets/icon/bookmark_guide.png',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                          SizedBox(height:30),
                          Text(
                              '북마크를 눌러 나만의 북마크 리스트를 만들어보세요!'
                          )
                        ],
                      )
                      : ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = filterList[index];
                            final userBookmark = userBookmarks
                                .where((b) => b.restaurantId == item.id).firstOrNull;
                            return MyRestaurantItem(
                              restaurant: item,
                              userBookmark: userBookmark,
                              onTap: () {
                                IsbookmarkDialog.show(
                                  context: context,
                                  selectedIcon : userBookmark?.bookmark,
                                  tappedIcon: userBookmark?.bookmark,
                                  myMemo : userBookmark?.myMemo,
                                  onConfirm: (memo) {
                                    ref.read(userBookmarkProvider.notifier).toggleBookmark(
                                        item.id,
                                        userBookmark?.bookmark ?? 0,
                                        memo,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
            Container(
              height: 8.0,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.white,
        child: const Icon(
            Icons.arrow_back,
            color: const Color(0xFFFF7A00)
      ),
      ),
    );
  }


}