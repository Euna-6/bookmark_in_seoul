import 'package:bookmark_in_seoul/model/user_bookmark.dart';
import 'package:bookmark_in_seoul/providers/auth_provider.dart';
import 'package:bookmark_in_seoul/providers/restaurant_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserBookmarkNotifier extends Notifier<List<UserBookmark>> {

  @override
  List<UserBookmark> build() {
    _loadBookmarks();
    return [];
  }

  // 현재 로그인한 유저의 북마크 목록 가져오기
  Future<void> _loadBookmarks() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final repo = ref.read(restaurantRepositoryProvider);
    state = await repo.fetchUserBookmark(user.uid);
  }

  // 북마크 설정/해제/변경
  Future<void> toggleBookmark(String restaurantId, int iconType, String? memo) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final repo = ref.read(restaurantRepositoryProvider);

    // 현재 북마크 상태 확인
    final existing = state.where((b) => b.restaurantId == restaurantId).firstOrNull;
    final currentBookmark = existing?.bookmark ?? 0;

    if (currentBookmark == iconType) {
      // 같은 아이콘 눌렀을 때는 카운트를 차감하고 Firestore에서 북마크를 삭제한다
      await ref.read(restaurantProvider.notifier).updateCount(restaurantId, iconType, -1);
      await repo.removeUserBookmark(user.uid, restaurantId);

      // state 업데이트
      state = state.where((b) => b.restaurantId != restaurantId).toList();

    } else {
      // 다른 아이콘이 설정 되어있는 상태라면 카운트를 차감한다
      if (currentBookmark != 0) {
        await ref.read(restaurantProvider.notifier).updateCount(restaurantId, currentBookmark, -1);
      }

      // 새 아이콘 카운트 증가
      await ref.read(restaurantProvider.notifier).updateCount(restaurantId, iconType, 1);

      // 새 북마크 생성
      final newBookmark = UserBookmark(
        restaurantId: restaurantId,
        isBookmarked: true,
        bookmark: iconType,
        myMemo: memo,
        updatedAt: DateTime.now(),
      );

      // Firestore에 저장
      await repo.setUserBookmark(user.uid, newBookmark);

      // state 업데이트
      state = [
        // 기존에 북마크가 되어있던 것이면 newBookmark로 교체
        for (final b in state)
          if (b.restaurantId == restaurantId) newBookmark else b,
        // 북마크 안되어있었던거면 추가
        if (existing == null) newBookmark,
      ];
    }
  }

  // 메모 수정
  Future<void> updateMemo(String restaurantId, String? memo) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final repo = ref.read(restaurantRepositoryProvider);

    state = [
      for (final b in state)
        if (b.restaurantId == restaurantId)
          b.copyWith(myMemo: memo, clearMemo: memo == null)
        else b,
    ];

    final updatedBookmark = state.firstWhere((b) => b.restaurantId == restaurantId);
    await repo.setUserBookmark(user.uid, updatedBookmark);
  }
}

final userBookmarkProvider = NotifierProvider<UserBookmarkNotifier, List<UserBookmark>>(
      () => UserBookmarkNotifier(),
);

// 특정 식당의 북마크 정보를 가져오는 Provider
final userBookmarkByRestaurantProvider = Provider.family<UserBookmark?, String>((ref, restaurantId) {
  return ref.watch(userBookmarkProvider)
      .where((b) => b.restaurantId == restaurantId)
      .firstOrNull;
});