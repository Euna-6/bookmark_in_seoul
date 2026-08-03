import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:bookmark_in_seoul/component/isbookmark_dialog.dart';
import 'package:bookmark_in_seoul/component/menu_item.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
import 'package:flutter/material.dart';
import '../model/menu.dart';
import '../model/restaurant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailRestaurant extends ConsumerStatefulWidget {
  final Restaurant restaurant;

  const DetailRestaurant({super.key, required this.restaurant});

  @override
  ConsumerState<DetailRestaurant> createState() => _DetailRestaurantState();
}

class _DetailRestaurantState extends ConsumerState<DetailRestaurant> {
  List<Menu> _menuList = [];  // 메뉴 상태 관리
  bool _isMenuLoading = true; // 메뉴 로딩 상태

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadMenu());
  }

  Future<void> _loadMenu() async {
    final repo = ref.read(restaurantRepositoryProvider);
    final menus = await repo.fetchMenu(widget.restaurant.id);
    setState(() {
      _menuList = menus;
      _isMenuLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 보고 있는 식당에 해당하는 id를 찾아서 저장.
    final restaurant = ref.watch(restaurantProvider).firstWhere((e)=>e.id == widget.restaurant.id);

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
                          restaurant: restaurant,
                          onTap: () {
                            IsbookmarkDialog.show(
                                context: context,
                                selectedIcon: restaurant.isBookmarked ? restaurant.bookmark : null,
                                tappedIcon: 1,
                                onConfirm: () {
                                  ref.read(restaurantProvider.notifier).toggleBookmark(
                                      restaurant.id,
                                      1,
                                  );
                                }
                            );
                          },
                        ),
                        cntBookmark(
                          bookmark: 2,
                          restaurant: restaurant,
                          onTap: () {
                            IsbookmarkDialog.show(
                                context: context,
                                selectedIcon: restaurant.isBookmarked ? restaurant.bookmark : null,
                                tappedIcon: 2,
                                onConfirm: () {
                                  ref.read(restaurantProvider.notifier).toggleBookmark(
                                    restaurant.id,
                                    2,
                                  );
                                }
                            );
                          },
                        ),
                        cntBookmark(
                          bookmark: 3,
                          restaurant: restaurant,
                          onTap: () {
                            IsbookmarkDialog.show(
                                context: context,
                                selectedIcon: restaurant.isBookmarked ? restaurant.bookmark : null,
                                tappedIcon: 3,
                                onConfirm: () {
                                  ref.read(restaurantProvider.notifier).toggleBookmark(
                                    restaurant.id,
                                    3,
                                  );
                                }
                            );
                          },
                        ),
                        cntBookmark(
                          bookmark: 4,
                          restaurant: restaurant,
                          onTap: () {
                            IsbookmarkDialog.show(
                                context: context,
                                selectedIcon: restaurant.isBookmarked ? restaurant.bookmark : null,
                                tappedIcon: 4,
                                onConfirm: () {
                                  ref.read(restaurantProvider.notifier).toggleBookmark(
                                    restaurant.id,
                                    4,
                                  );
                                }
                            );
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
          if (_isMenuLoading) // 메뉴 가져오는 중. 로딩 스피너 표시
            SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_menuList.isEmpty) // 메뉴 없을때.
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
                    MenuItem(menu: _menuList[index]),
                childCount: _menuList.length
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
