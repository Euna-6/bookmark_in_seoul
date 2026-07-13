import 'package:bookmark_in_seoul/component/filter_box.dart';
import 'package:bookmark_in_seoul/providers/bookmark_sort_provider.dart';
import 'package:bookmark_in_seoul/providers/district_filter_provider.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
import 'package:bookmark_in_seoul/screen/my_bookmark.dart';
import 'package:flutter/material.dart';
import 'package:bookmark_in_seoul/component/restaurant_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../component/isbookmark_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(districtFilterProvider.notifier).state = '영등포구';
      ref.read(bookmarkSortProvider.notifier).state = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantList = ref.watch(sortedBookmarkProvider);
    return Scaffold(
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상단 로고 부분
              SizedBox(height: 15),
              Image.asset(
                'assets/icon/icon.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 15),
              // 지역별, 북마크별 정렬 설정 박스 UI
              SizedBox(
                  height: 95,
                  child: FilterBox(mode: FilterMode.sort)
              ),
              // 하단 식당 목록
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right:16.0, top:16.0,
                  ),
                  child: Container(
                    color: const Color(0xFFFDEFD9),
                    child: restaurantList.isEmpty
                    ? Center(child: Text("등록된 식당이 없어요!"))
                    : ListView.builder(
                      itemCount: restaurantList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = restaurantList[index];
                        return RestaurantItem(
                          index: index,
                          iconType: (item.isBookmarked) ? item.bookmark : null,
                          restaurant: item,
                          onTap: (iconType) {
                            IsbookmarkDialog.show(
                                context: context,
                                selectedIcon : item.bookmark,
                                tappedIcon: iconType,
                                onConfirm: () {
                                  ref.read(restaurantProvider.notifier).toggleBookmark(
                                      item.id,
                                      iconType
                                  );
                                }
                            );
                          }
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
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => MyBookmark(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var begin = const Offset(0.0, 1.0);
                var end = Offset.zero;
                var curve = Curves.ease; // 부드러운 움직임 효과

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
          ref.read(districtFilterProvider.notifier).state = '영등포구';
          setState(() {
            // MyBookmark에서 pop 되었을때 build 재실행하여 UI 업데이트
          });
          },
        backgroundColor: Colors.white,
        child: const Icon(
            Icons.bookmarks,
            color: const Color(0xFFE57022)
        ),
      ),
    );
  }


}