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
  //final List<Restaurant> sampleRestaurant = sampleData;
  final List<Restaurant> bookmarkedList = sampleData.where((item)=>
    item.bookmark > 0).toList();

  // 북마크 아이콘 선택 시에 '해제하시겠습니까' 팝업 띄우는 함수
  Future<void> unbookmark(Restaurant restaurant) async {
    bool? shouldRemove = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content : Text("${restaurant.restaurantName}의 북마크를 해제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context,false),
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context,true),
              child: Text("해제"),
            ),
          ],
        )
    );

    if (shouldRemove == true){
      setState(() {
        restaurant.isBookmarked=false;
        restaurant.bookmark=0;
        restaurant.myMemo=null;
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
              Container(
                height: 100,
                width: 100,
                color: Colors.green,
              ),
              SizedBox(height: 15),
              // 상단 북마크별 보기 설정
              SizedBox(
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
                        child: _FilterBookmark(),
                      ),
                    ),
                    SizedBox(width:16,),
                  ],
                ),
              ),
              // 하단 식당 목록
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right:16.0, top:16.0
                  ),
                  child: Container(
                    color: const Color(0xFFEAEAEA),
                    child: ListView.builder(
                      itemCount: bookmarkedList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = bookmarkedList[index];
                        return MyRestaurantItem(
                          restaurant: item,
                          onTap : () => unbookmark(item),
                        );
                      },),
                  ),
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
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
  const _FilterBookmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BookmarkIcon(
                bookmark: 1,
                size: 45,
                onTap: (){},
              ),
              BookmarkIcon(
                bookmark: 2,
                size: 45,
                onTap: (){},
              ),
              BookmarkIcon(
                bookmark: 3,
                size: 45,
                onTap: (){},
              ),
              BookmarkIcon(
                bookmark: 4,
                size: 45,
                onTap: (){},
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}
