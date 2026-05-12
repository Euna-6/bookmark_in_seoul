import 'package:bookmark_in_seoul/component/filter_box.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
import 'package:bookmark_in_seoul/screen/my_bookmark.dart';
import 'package:flutter/material.dart';
import 'package:bookmark_in_seoul/component/restaurant_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ListView 상태 관리 위한 변수. 선택된 아이콘을 뜻함.
  // int? _iconType;

  @override
  Widget build(BuildContext context) {
    final restaurantList = ref.watch(restaurantProvider);
    final localRestaurants = restaurantList.where((res)=>res.district=="영등포구").toList();
    return Scaffold(
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상단 로고 부분
              SizedBox(height: 15),
              Container(
                height: 100,
                width: 100,
                color: Colors.green,
              ),
              SizedBox(height: 15),
              // 지역별, 북마크별 정렬 설정 박스 UI
              SizedBox(
                  height: 95,
                  child: FilterBox()
              ),
              // 하단 식당 목록
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right:16.0, top:16.0,
                  ),
                  child: Container(
                    color: const Color(0xFFEAEAEA),
                    child: localRestaurants.isEmpty
                    ? Center(child: Text("등록된 식당이 없어요!"))
                    : ListView.builder(
                      itemCount: localRestaurants.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = localRestaurants[index];
                        return RestaurantItem(
                          index: index,
                          iconType: (item.isBookmarked) ? item.bookmark : null,
                          restaurant: item,
                          onTap: (iconType) =>
                            ref.read(restaurantProvider.notifier).toggleBookmark(item.id, iconType),
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
            //MaterialPageRoute(builder: (context) => MyBookmark()),
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
          setState(() {
            // MyBookmark에서 pop 되었을때 build 재실행하여 UI 업데이트
          });
          },
        backgroundColor: Colors.white,
        child: const Icon(Icons.bookmarks),
      ),
    );
  }
}

class _Filter extends StatelessWidget {
  const _Filter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: 16,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(16.0),
            child:
            Row(
              children: [
                SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('지역'),
                      SizedBox(height:10,),
                      Text('영등포구',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('정렬'),
                      SizedBox(height:10,),
                      Text('별',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width:16,),
      ],
    );
  }
}
