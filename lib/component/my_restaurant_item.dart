import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:bookmark_in_seoul/model/user_bookmark.dart';
import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import '../screen/detail_restaurant.dart';

class MyRestaurantItem extends StatelessWidget {
  final Restaurant restaurant;
  final UserBookmark? userBookmark;
  final VoidCallback onTap;

  const MyRestaurantItem({
    super.key,
    required this.restaurant,
    this.userBookmark,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                DetailRestaurant(
                    restaurant: restaurant,
                    userBookmark: userBookmark,
                ),
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
                    color: Color(0xFFE57022),
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
                            ),
                            // 내가 설정한 북마크
                            BookmarkIcon(
                              bookmark: userBookmark?.bookmark ?? 0,
                              isBookmarked: userBookmark?.isBookmarked ?? false,
                              size: 21,
                              onTap: onTap,
                            ),
                          ],
                        ),
                        Text(userBookmark?.myMemo??"",
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
