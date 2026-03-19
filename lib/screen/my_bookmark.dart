import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:flutter/material.dart';
import '../component/my_restaurant_item.dart';
import '../model/restaurant.dart';
import '../data/sample_data.dart';

class MyBookmark extends StatelessWidget {
  MyBookmark({super.key});

  //final List<Restaurant> sampleRestaurant = sampleData;
  final List<Restaurant> bookmarkedList = sampleData.where((item)=>
    item.bookmark > 0).toList();

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
              // 북마크별 보기 설정
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
                        ),
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
