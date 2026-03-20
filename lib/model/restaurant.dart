import 'package:intl/intl.dart';
import 'menu.dart';

class Restaurant{
  // 식당 이름
  final String restaurantName;
  // 식당 위치
  final String district;
  // 식당 이미지
  final String? imgUrl;
  // 북마크 '별' 갯수
  int cntStar;
  // 북마크 '하트' 갯수
  int cntHeart;
  // 북마크 '체크' 갯수
  int cntCheck;
  // 북마크 'X' 갯수
  int cntX;
  // 개인의 북마크 설정 유무 확인
  bool isBookmarked;
  // 본인이 설정한 북마크
  int bookmark;
  // 식당에 대한 개인 메모
  String? myMemo;
  // 메뉴 정보
  final List<Menu>? menuList;

  // 생성자
  Restaurant({
    required this.restaurantName,
    required this.district,
    this.imgUrl,
    this.cntStar=0,
    this.cntHeart=0,
    this.cntCheck=0,
    this.cntX=0,
    this.isBookmarked=false,
    this.bookmark=0,
    this.myMemo,
    this.menuList,
  });

  // 북마크 설정 및 해제 함수
  void updateBookmark(int type){
    // 선택된 것을 누르면 해제 : 선택 안된것을 누르면 선택설정
    if(isBookmarked && bookmark == type){
      isBookmarked = false;
      bookmark = 0;
    } else {
      isBookmarked = true;
      bookmark = type;
    }
  }

  // 숫자가 1000이 넘을 경우 K를 붙여서 축소
  // 북마크별로 각자 getter 생성
  String get formatCntStar {
    if (cntStar >= 1000){
      return NumberFormat.compact().format(cntStar);
    }
    return cntStar.toString();
  }
  String get formatCntHeart {
    if (cntHeart >= 1000){
      return NumberFormat.compact().format(cntHeart);
    }
    return cntHeart.toString();
  }
  String get formatCntCheck {
    if (cntCheck >= 1000){
      return NumberFormat.compact().format(cntCheck);
    }
    return cntCheck.toString();
  }
  String get formatCntX {
    if (cntX >= 1000){
      return NumberFormat.compact().format(cntX);
    }
    return cntX.toString();
  }

}