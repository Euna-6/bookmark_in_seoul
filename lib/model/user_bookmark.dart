class UserBookmark {
  final String restaurantId;  // Primary Key
  final bool isBookmarked;    // 북마크 설정 유무
  final int bookmark;         // 0: non, 1: star, 2: heart, 3: check, 4: X
  final String? myMemo;       // 식당에 대한 개인 메모
  final DateTime? updatedAt;  // 마지막 수정일

  UserBookmark({
    required this.restaurantId,
    this.isBookmarked = false,
    this.bookmark = 0,
    this.myMemo,
    this.updatedAt,
  });

  UserBookmark copyWith({
    String? restaurantId,
    bool? isBookmarked,
    int? bookmark,
    String? myMemo,
    bool clearMemo = false,
    DateTime? updatedAt,
  }) {
    return UserBookmark(
      restaurantId: restaurantId ?? this.restaurantId,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      bookmark: bookmark ?? this.bookmark,
      myMemo: clearMemo ? null : (myMemo ?? this.myMemo),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Firestore 저장을 위한 객체->Map 변환 함수
  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'isBookmarked': isBookmarked,
      'bookmark': bookmark,
      'myMemo': myMemo,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Firestore 읽기위한 문서->객체 변환 함수
  factory UserBookmark.fromMap(Map<String, dynamic> map) {
    return UserBookmark(
      restaurantId: map['restaurantId'],
      isBookmarked: map['isBookmarked'] ?? false,
      bookmark: map['bookmark'] ?? 0,
      myMemo: map['myMemo'],
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }
}