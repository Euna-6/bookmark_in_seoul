import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  final Geocoding geocoding = Geocoding(locale: const Locale('ko', 'KR'));

  // 현재 위치에서 '구' 이름 얻기
  Future<String?> getCurrentDistrict() async {

    // 위치 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();

    /*
    1. while using the app (앱 사용 중에만 허용)
     :  LocationPermission.whileInUse
        영구적 허용으로 앱을 껐다 켜도 팝업이 뜨지 않음
    2. Only this time (이번만 허용)
     :  앱 종료 후 or 일정 시간 후에 권한이 회수되어 팝업이 다시 뜸
    3. Don't allow (허용 안 함)
     :  1번 거절->LocationPermission.denied 되고 다시 팝업 띄울 수 있음
        2번 거절->LocationPermission.deniedForever 되어 영구 거절
                 사용자가 수동으로 권한 켜야 함
     */

    if(permission == LocationPermission.denied){
      print('[LocationService] 권한 거부');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 팝업에서 사용자가 거부를 누름
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      //await Geolocator.openAppSettings();
    }

    // 현재 위도, 경도 가져오기
    final position = await Geolocator.getCurrentPosition();

    // 위도, 경도를 주소로 변환
    List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) return null;

    final placemark = placemarks.first;
    print('[LocationService] ${placemark.administrativeArea} ${placemark.subLocality}');

    // 구 이름 추출
    return _extractDistrict(placemark);
  }

  // 주소에서 구 추출
  String? _extractDistrict(Placemark placemark) {
    // subLocality: 강남구, 마포구 등
    final subLocality = placemark.subLocality ?? '';
    if (subLocality.endsWith('구')) return subLocality;
    return null;
  }

}