import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  final Geocoding geocoding = Geocoding(locale: const Locale('ko', 'KR'));

  // 현재 위치에서 '구' 이름 얻기
  Future<String?> getCurrentDistrict() async {

    // 위치 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    if(permission != LocationPermission.always
        && permission != LocationPermission.whileInUse){
      throw Exception('위치 권한을 허가 해주세요');
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