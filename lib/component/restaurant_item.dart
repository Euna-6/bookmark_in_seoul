import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:bookmark_in_seoul/model/user_bookmark.dart';
import 'package:bookmark_in_seoul/screen/detail_restaurant.dart';
import 'package:flutter/material.dart';
import '../model/restaurant.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;
  final UserBookmark? userBookmark;
  final int index;
  final int? iconType;
  final Function(int) onTap;

  const RestaurantItem({
    super.key,
    required this.restaurant,
    this.userBookmark,
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
            builder: (context) => DetailRestaurant(
              restaurant: restaurant,
              userBookmark: userBookmark,
            ),
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
                Container(color: Color(0xFFE57022), height: 85, width: 85),
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
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      // 북마크 갯수 확인 UI
                      cntBookmark(
                        restaurant: restaurant,
                        userBookmark: userBookmark,
                        iconType: iconType,
                        onTap: onTap,
                      ),
                      SizedBox(height:2),
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
  final UserBookmark? userBookmark;
  final int? iconType;
  final Function(int) onTap;

  const cntBookmark({
    required this.restaurant,
    this.userBookmark,
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
                    isBookmarked: userBookmark?.bookmark == 1,
                    onTap: () {
                      onTap(1);
                    },
                  ),
                  SizedBox(width: 2),
                  SizedBox(width: 65, child: Text(restaurant.formatCntStar)),
                  BookmarkIcon(bookmark: 2,
                    isBookmarked: userBookmark?.bookmark == 2,
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
                    isBookmarked: userBookmark?.bookmark == 3,
                    onTap: () {
                      onTap(3);
                    },),
                  SizedBox(width: 2),
                  SizedBox(width: 65, child: Text(restaurant.formatCntCheck)),
                  BookmarkIcon(
                    bookmark: 4,
                    isBookmarked: userBookmark?.bookmark == 4,
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
