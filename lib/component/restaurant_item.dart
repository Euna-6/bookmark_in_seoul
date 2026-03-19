import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:bookmark_in_seoul/screen/detail_restaurant.dart';
import 'package:flutter/material.dart';
import '../model/restaurant.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItem({
    super.key,
    required this.restaurant,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant.restaurantName,
                        style: TextStyle(
                        fontSize: 23.5,
                        fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // 북마크 갯수 확인 UI
                      cntBookmark(restaurant : restaurant),
                    ],
                  ),
                ),
                // 우측 아이콘
                /*
                BookmarkIcon(
                  bookmark: restaurant.bookmark,
                  size: 48,
                  isBookmarked: true,
                ),
                SizedBox(width:10),

                 */
              ],
            ),
          ),
        )
      ),
    );
  }
}

// 식당의 북마크 갯수 정보 UI
class cntBookmark extends StatelessWidget {
  final Restaurant restaurant;

  const cntBookmark({
    required this.restaurant,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BookmarkIcon(bookmark: 1),
                    SizedBox(width:2),
                    SizedBox(
                        width: 65,
                        child: Text(restaurant.formatCntStar)
                    ),
                    BookmarkIcon(bookmark: 2),
                    SizedBox(width:2),
                    SizedBox(
                        width: 65,
                        child: Text(restaurant.formatCntHeart)
                    ),
                  ],
                ),
                Row(
                  children: [
                    BookmarkIcon(bookmark: 3),
                    SizedBox(width:2),
                    SizedBox(
                        width: 65,
                        child: Text(restaurant.formatCntCheck)
                    ),
                    BookmarkIcon(bookmark: 4),
                    SizedBox(width:2),
                    SizedBox(
                        width: 65,
                        child: Text(restaurant.formatCntX)
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
    );
  }
}

