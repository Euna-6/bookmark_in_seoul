import 'package:bookmark_in_seoul/component/bookmark_icon.dart';
import 'package:bookmark_in_seoul/component/isbookmark_dialog.dart';
import 'package:bookmark_in_seoul/component/menu_item.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
import 'package:bookmark_in_seoul/providers/user_bookmark_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/menu.dart';
import '../model/restaurant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_bookmark.dart';

class DetailRestaurant extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  final UserBookmark? userBookmark;

  const DetailRestaurant({
    super.key,
    required this.restaurant,
    this.userBookmark,
  });

  @override
  ConsumerState<DetailRestaurant> createState() => _DetailRestaurantState();
}

class _DetailRestaurantState extends ConsumerState<DetailRestaurant> {
  List<Menu> _menuList = [];  // 메뉴 상태 관리
  bool _isMenuLoading = true; // 메뉴 로딩 상태
  GoogleMapController? _mapController;

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
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 현재 보고 있는 식당에 해당하는 id를 찾아서 저장.
    final restaurant = ref.watch(restaurantProvider).firstWhere((e)=>e.id == widget.restaurant.id);

    final userBookmark = ref.watch(userBookmarkProvider)
        .where((b) => b.restaurantId == restaurant.id).firstOrNull;


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
          // 식당 이름, 북마크 아이콘, 북마크 갯수, 사용자 메모, 지도 UI
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                      bottom: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cntBookmark(
                          bookmark: 1,
                          restaurant: restaurant,
                          userBookmark: userBookmark,
                          onTap: () {
                            IsbookmarkDialog.show(
                                context: context,
                                selectedIcon: userBookmark?.bookmark,
                                tappedIcon: 1,
                                myMemo : userBookmark?.myMemo,
                                onConfirm: (memo) {
                                  ref.read(userBookmarkProvider.notifier).toggleBookmark(
                                      restaurant.id,
                                      1,
                                      memo,
                                  );
                                },
                            );
                          },
                        ),
                        cntBookmark(
                          bookmark: 2,
                          restaurant: restaurant,
                          userBookmark: userBookmark,
                          onTap: () {
                            IsbookmarkDialog.show(
                              context: context,
                              selectedIcon: userBookmark?.bookmark,
                              tappedIcon: 2,
                              myMemo : userBookmark?.myMemo,
                              onConfirm: (memo) {
                                ref.read(userBookmarkProvider.notifier).toggleBookmark(
                                  restaurant.id,
                                  2,
                                  memo,
                                );
                              },
                            );
                          },
                        ),
                        cntBookmark(
                          bookmark: 3,
                          restaurant: restaurant,
                          userBookmark: userBookmark,
                          onTap: () {
                            IsbookmarkDialog.show(
                              context: context,
                              selectedIcon: userBookmark?.bookmark,
                              tappedIcon: 3,
                              myMemo : userBookmark?.myMemo,
                              onConfirm: (memo) {
                                ref.read(userBookmarkProvider.notifier).toggleBookmark(
                                  restaurant.id,
                                  3,
                                  memo,
                                );
                              },
                            );
                          },
                        ),
                        cntBookmark(
                          bookmark: 4,
                          restaurant: restaurant,
                          userBookmark: userBookmark,
                          onTap: () {
                            IsbookmarkDialog.show(
                              context: context,
                              selectedIcon: userBookmark?.bookmark,
                              tappedIcon: 4,
                              myMemo : userBookmark?.myMemo,
                              onConfirm: (memo) {
                                ref.read(userBookmarkProvider.notifier).toggleBookmark(
                                  restaurant.id,
                                  4,
                                  memo,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // 사용자 메모
                  if(userBookmark?.myMemo != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left:20,
                        right:20,
                      ),
                      child: Column(
                        children: [
                          Text("나의 메모",
                            style: TextStyle(
                              fontSize:11,
                              fontWeight: FontWeight.w500,
                            ),),
                          Text(
                            userBookmark!.myMemo!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF505050),
                            ),),
                          SizedBox(height:4),
                          GestureDetector(
                            onTap: () {
                              MemoDialog.show(
                                context: context,
                                myMemo: userBookmark.myMemo!,
                                onConfirm: (memo){
                                  ref.read(userBookmarkProvider.notifier).updateMemo(
                                      restaurant.id,
                                      memo
                                  );
                                }
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              size: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  // 지도
                  SizedBox(height:24,),
                  _buildMap(),
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

  // _mapController 를 이 클래스에 선언해두었기 때문에
  // class로 분리하지 않고 함수로 작성
  Widget _buildMap() {
    // 위도, 경도 정보가 없으면 지도 표시 안 함
    if (widget.restaurant.latitude == null || widget.restaurant.longitude == null) {
      return Container(
        height: 220,
        color: Colors.grey,
        child: Center(
          child: Text(
            '위치 정보가 없어요!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.restaurant.latitude!,
            widget.restaurant.longitude!,
          ),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.restaurant.id),
            position: LatLng(
              widget.restaurant.latitude!,
              widget.restaurant.longitude!,
            ),
            infoWindow: InfoWindow(
              title: widget.restaurant.restaurantName,
            ),
          ),
        },
        onMapCreated: (controller) {
          _mapController = controller;
        },
        gestureRecognizers: {
          // 지도 사용 시에 화면이 스크롤되는 경우를 방지
          Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
          ),
        },
        scrollGesturesEnabled: true,
      ),
    );
  }
}

// 식당 북마크 갯수 UI 클래스
class cntBookmark extends StatelessWidget {
  final int bookmark;
  final Restaurant restaurant;
  final UserBookmark? userBookmark;
  final VoidCallback onTap;

  const cntBookmark({
    super.key,
    required this.bookmark,
    required this.restaurant,
    this.userBookmark,
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
              isBookmarked: userBookmark?.bookmark == 1,
              onTap: () {
                onTap();
              },
            ),
            SizedBox(width:3),
            SizedBox(width: 54, child: Text(restaurant.formatCntStar)),
          ],
        );
      case 2:
        return Row(
          children: [
            BookmarkIcon(
              bookmark: 2,
              isBookmarked: userBookmark?.bookmark == 2,
              onTap: () {
                onTap();
              },
            ),
            SizedBox(width:3),
            SizedBox(width: 54, child: Text(restaurant.formatCntHeart)),
          ],
        );
      case 3:
        return Row(
          children: [
            BookmarkIcon(
              bookmark: 3,
              isBookmarked: userBookmark?.bookmark == 3,
              onTap: () {
                onTap();
              },
            ),
            SizedBox(width:3),
            SizedBox(width: 54, child: Text(restaurant.formatCntCheck)),
          ],
        );
      case 4:
        return Row(
          children: [
            BookmarkIcon(
              bookmark: 4,
              isBookmarked: userBookmark?.bookmark == 4,
              onTap: () {
                onTap();
              },
            ),
            SizedBox(width:3),
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

// 메모 편집 버튼
class MemoDialog extends StatefulWidget {
  final String myMemo;
  final Function(String? memo) onConfirm;

  const MemoDialog({
    super.key,
    required this.myMemo,
    required this.onConfirm,
  });

  @override
  State<MemoDialog> createState() => _MemoDialogState();

  static Future<void> show({
    required BuildContext context,
    required String myMemo,
    required Function(String? memo) onConfirm,
  }) {
    return showDialog<void>(
        context : context,
        builder : (context) => MemoDialog(
          onConfirm: onConfirm,
          myMemo: myMemo,
        )
    );
  }
}

class _MemoDialogState extends State<MemoDialog> {
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text:widget.myMemo);
  }
  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8.0),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _memoController,
              decoration: InputDecoration(
                    hintText: '메모를 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 12),
                  maxLines: 3,
                  maxLength: 66,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.pop(context),
          child: const Text("취소"),
        ),
        TextButton(
          onPressed: () {
            // 빈 문자열이면 null 처리
            final memo = _memoController.text.isEmpty
                ? null
                : _memoController.text;
            widget.onConfirm(memo);
            Navigator.pop(context);
          },
          child: const Text("변경"),
        ),
      ],
    );
  }
}

