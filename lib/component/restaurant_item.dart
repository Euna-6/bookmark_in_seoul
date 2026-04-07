import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:bookmark_in_seoul/screen/detail_restaurant.dart';
import 'package:flutter/material.dart';
import '../model/restaurant.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;
  final int index;
  final int? iconType;
  final Function(int) onTap;

  const RestaurantItem({
    super.key,
    required this.restaurant,
    required this.index,
    required this.iconType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRestaurant(restaurant: restaurant, ),
          ),
        );
        //onTap(-1);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 식당 사진
                Container(color: Colors.blue, height: 85, width: 85),
                SizedBox(width: 13),
                // 식당 정보
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 식당 이름
                      Text(
                        restaurant.restaurantName,
                        style: TextStyle(
                          fontSize: 23.5,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      // 북마크 갯수 확인 UI
                      cntBookmark(
                        restaurant: restaurant,
                        iconType: iconType,
                        onTap: onTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 식당의 북마크 아이콘, 갯수 정보 UI
class cntBookmark extends StatelessWidget {
  final Restaurant restaurant;
  final int? iconType;
  final Function(int) onTap;

  const cntBookmark({
    required this.restaurant,
    super.key,
    required this.iconType,
    required this.onTap,
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
                  BookmarkIcon(
                    bookmark: 1,
                    isBookmarked: restaurant.bookmark == 1,
                    onTap: () {
                      onTap(1);
                    },
                  ),
                  SizedBox(width: 2),
                  SizedBox(width: 65, child: Text(restaurant.formatCntStar)),
                  BookmarkIcon(bookmark: 2,
                    isBookmarked: restaurant.bookmark == 2,
                    onTap: () {
                      onTap(2);
                    },),
                  SizedBox(width: 2),
                  SizedBox(width: 65, child: Text(restaurant.formatCntHeart)),
                ],
              ),
              Row(
                children: [
                  BookmarkIcon(
                    bookmark: 3,
                    isBookmarked: restaurant.bookmark == 3,
                    onTap: () {
                      onTap(3);
                    },),
                  SizedBox(width: 2),
                  SizedBox(width: 65, child: Text(restaurant.formatCntCheck)),
                  BookmarkIcon(
                    bookmark: 4,
                    isBookmarked: restaurant.bookmark == 4,
                    onTap: () {
                      onTap(4);
                    },),
                  SizedBox(width: 2),
                  SizedBox(width: 65, child: Text(restaurant.formatCntX)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
