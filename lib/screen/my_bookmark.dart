import 'package:bookmark_in_seoul/component/isbookmark_dialog.dart';
import 'package:bookmark_in_seoul/component/filter_box.dart';
import 'package:bookmark_in_seoul/providers/bookmark_filter_provider.dart';
import 'package:bookmark_in_seoul/providers/district_filter_provider.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 최상단 로고 부분
            SizedBox(height: 15),
            Image.asset(
              'assets/icon/icon.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 15),
            // 상단 북마크별 보기 설정
            SizedBox(
                height: 95,
                child: FilterBox(mode: FilterMode.filter)
            ),
            // 하단 식당 목록
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0, right:16.0, top:16.0,
                ),
                child: Container(
                  color: const Color(0xFFFDEFD9),
                  child: filterList.isEmpty
                      ? Center(child: Text("리스트가 비었어요"))
                      : ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = filterList[index];
                            return MyRestaurantItem(
                              restaurant: item,
                              onTap: () {
                                IsbookmarkDialog.show(
                                  context: context,
                                  selectedIcon : item.bookmark,
                                  tappedIcon: item.bookmark,
                                  onConfirm: (memo) {
                                    ref.read(restaurantProvider.notifier).toggleBookmark(
                                        item.id,
                                        item.bookmark,
                                        memo,
                                    );
                                  },
                                  myMemo : item.myMemo,
                                );
                              },
                            );
                          },
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
        child: const Icon(
            Icons.arrow_back,
            color: const Color(0xFFE57022)
      ),
      ),
    );
  }


}