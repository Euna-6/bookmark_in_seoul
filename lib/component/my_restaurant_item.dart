import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import '../screen/detail_restaurant.dart';

class MyRestaurantItem extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const MyRestaurantItem({
    super.key,
    required this.restaurant,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                DetailRestaurant(restaurant: restaurant),
            )
        );
      },
      child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left:16, top:16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 식당 사진
                  Container(
                    color: Colors.blue,
                    height: 85,
                    width: 85,
                  ),
                  SizedBox(width: 13,),
                  // 식당 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(restaurant.restaurantName,
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),// 내가 설정한 북마크
                            BookmarkIcon(
                              bookmark: restaurant.bookmark,
                              isBookmarked: restaurant.isBookmarked,
                              size: 21,
                              onTap: onTap,
                            ),
                          ],
                        ),
                        Text(restaurant.myMemo??"",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width:16),
                ],
              ),
            ),
          )
      ),
    );
  }
}
