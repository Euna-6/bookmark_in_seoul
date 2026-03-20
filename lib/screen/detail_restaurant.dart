import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:bookmark_in_seoul/component/menu_item.dart';
import 'package:flutter/material.dart';
import '../model/restaurant.dart';

class DetailRestaurant extends StatefulWidget {
  final Restaurant restaurant;

  const DetailRestaurant({super.key, required this.restaurant});

  @override
  State<DetailRestaurant> createState() => _DetailRestaurantState();
}

class _DetailRestaurantState extends State<DetailRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 아래로 스크롤 시에 상단 이미지를 사라지게 하기 위한 스크롤뷰
      body: CustomScrollView(
        slivers: [
          // 상단 이미지 영역
          SliverAppBar(
            expandedHeight: 210.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.restaurant.imgUrl != null
                  ? Image.network(widget.restaurant.imgUrl!, fit: BoxFit.cover)
                  : Container(
                      // 이미지가 없는 경우
                      color: const Color(0xFFCCCCCC),
                      child: const Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          // 식당 이름, 북마크 아이콘, 북마크 갯수, 지도 UI
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.restaurant.restaurantName,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 8,
                      bottom: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cntBookmark(
                          bookmark: 1,
                          restaurant: widget.restaurant,
                          onTap: () {
                            setState(() {
                              widget.restaurant.updateBookmark(1);
                            });
                          },
                        ),
                        cntBookmark(
                          bookmark: 2,
                          restaurant: widget.restaurant,
                          onTap: () {
                            setState(() {
                              widget.restaurant.updateBookmark(2);
                            });
                          },
                        ),
                        cntBookmark(
                          bookmark: 3,
                          restaurant: widget.restaurant,
                          onTap: () {
                            setState(() {
                              widget.restaurant.updateBookmark(3);
                            });
                          },
                        ),
                        cntBookmark(
                          bookmark: 4,
                          restaurant: widget.restaurant,
                          onTap: () {
                            setState(() {
                              widget.restaurant.updateBookmark(4);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // 지도
                  Container(height: 200, color: Colors.grey),
                  const Divider(height: 50, thickness: 1, color: Colors.grey),
                ],
              ),
            ),
          ),
          /*
          하단 위젯은 메뉴 리스트를 출력함
          Column & for 를 쓰면 간단하지만 리스트 아이템이 많을때 비효율적.
          해당 위젯엔 아이템이 적을 것으로 예상되지만
          Lazy Loading 학습을 위해 SliverList를 사용
          */
          // 메뉴 리스트가 없을 경우
          if (widget.restaurant.menuList == null ||
              widget.restaurant.menuList!.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        "등록된 메뉴 정보가 없어요!",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            // 메뉴가 있을 때만 SliverList 보여주기
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    MenuItem(menu: widget.restaurant.menuList![index]),
                childCount: widget.restaurant.menuList!.length,
              ),
            ),
          // 마지막 아이템 하단에 여백
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// 식당 북마크 갯수 UI 클래스
class cntBookmark extends StatelessWidget {
  final int bookmark;
  final Restaurant restaurant;
  final VoidCallback onTap;

  const cntBookmark({
    super.key,
    required this.bookmark,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (bookmark) {
      case 1:
        return Row(
          children: [
            BookmarkIcon(
              bookmark: 1,
              isBookmarked: restaurant.isBookmarked && restaurant.bookmark==1,
              onTap: () {
                onTap();
              },
            ),
            SizedBox(width: 54, child: Text(restaurant.formatCntStar)),
          ],
        );
      case 2:
        return Row(
          children: [
            BookmarkIcon(
              bookmark: 2,
              isBookmarked: restaurant.isBookmarked && restaurant.bookmark==2,
              onTap: () {
                onTap();
              },
            ),
            SizedBox(width: 54, child: Text(restaurant.formatCntHeart)),
          ],
        );
      case 3:
        return Row(
          children: [
            BookmarkIcon(
              bookmark: 3,
              isBookmarked: restaurant.isBookmarked && restaurant.bookmark==3,
              onTap: () {
                onTap();
              },
            ),
            SizedBox(width: 54, child: Text(restaurant.formatCntCheck)),
          ],
        );
      case 4:
        return Row(
          children: [
            BookmarkIcon(
              bookmark: 4,
              isBookmarked: restaurant.isBookmarked && restaurant.bookmark==4,
              onTap: () {
                onTap();
              },
            ),
            SizedBox(width: 54, child: Text(restaurant.formatCntX)),
          ],
        );
      default:
        return Row(
          children: [
            Icon(Icons.error_outline, color: Colors.grey),
            Text('?'),
          ],
        );
    }
  }
}
