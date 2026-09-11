import 'package:intl/intl.dart';
import 'menu.dart';

class Restaurant{
  // 식당 고유 아이디 (Primary Key)
  final String id;
  // 식당 이름
  final String restaurantName;
  // 식당 위치
  final String district;
  // 식당 이미지
  final String? imgUrl;
  // 북마크 '별' 갯수
  final int cntStar;
  // 북마크 '하트' 갯수
  final int cntHeart;
  // 북마크 '체크' 갯수
  final int cntCheck;
  // 북마크 'X' 갯수
  final int cntX;
  // 메뉴 정보
  final List<Menu>? menuList;
  // 지도에 필요한 위도와 경도
  final double? latitude;
  final double? longitude;

  // 생성자
  Restaurant({
    required this.id,
    required this.restaurantName,
    required this.district,
    this.imgUrl,
    this.cntStar=0,
    this.cntHeart=0,
    this.cntCheck=0,
    this.cntX=0,
    this.menuList,
    this.latitude,
    this.longitude,
  });

  // 불변성 유지를 위해 객체 내부 멤버 값을 직접 변경시키지 않고 copyWith을 통해 새 객체가 생성되도록 함
  Restaurant copyWith({
    String? id,
    String? restaurantName,
    String? district,
    String? imgUrl,
    int? cntStar,
    int? cntHeart,
    int? cntCheck,
    int? cntX,
    List<Menu>? menuList,
    double? latitude,
    double? longitude,
}) {
    return Restaurant(
        id: id ?? this.id,
        restaurantName: restaurantName ?? this.restaurantName,
        district: district ?? this.district,
        imgUrl: imgUrl ?? this.imgUrl,
        cntStar: cntStar ?? this.cntStar,
        cntHeart: cntHeart ?? this.cntHeart,
        cntCheck: cntCheck ?? this.cntCheck,
        cntX: cntX ?? this.cntX,
        menuList: menuList ?? this.menuList,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
    );
  }

  // Firestore 연동을 위한 객체->Map 변환 함수
  Map<String, dynamic> toMap() {
    return {
      'restaurantName' : restaurantName,
      'district' : district,
      'imgUrl' : imgUrl,
      'cntStar' : cntStar,
      'cntHeart' : cntHeart,
      'cntCheck' : cntCheck,
      'cntX' : cntX,
      'latitude' : latitude,
      'longitude' : longitude,
    };
  }

  // Firestore 문서->객체 변환 함수
  factory Restaurant.fromMap(Map<String, dynamic> map, List<Menu> menuList, {required String id}){
    return Restaurant(
      id: id, //Firestore 문서 ID를 직접 받음
      restaurantName: map['restaurantName'],
      district: map['district'],
      imgUrl: map['imgUrl'],
      cntStar: map['cntStar'] ?? 0,
      cntHeart: map['cntHeart'] ?? 0,
      cntCheck: map['cntCheck'] ?? 0,
      cntX: map['cntX'] ?? 0,
      latitude: map['latitude'],
      longitude: map['longitude'],
      menuList: menuList,
    );
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