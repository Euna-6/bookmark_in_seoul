import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/restaurant.dart';

class KakaoApiService {
  final String _apiKey = dotenv.env['REST_API_KEY']
      ?? (throw Exception('REST_API_KEY가 .env에 없음'));
  // 키워드로 검색 (**구)
  final String _baseUrl = 'https://dapi.kakao.com/v2/local/search/keyword.json';

  Future<List<Restaurant>> searchRestaurants(String keyword) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'query': keyword, // **구
        'category_group_code': 'FD6',  // FD6 = 음식점 카테고리
        'size': '15',                   // 한 번에 가져올 개수 (최대 45)
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'KakaoAK $_apiKey',
      },
    );

    if (response.statusCode == 200) { // 성공
      final data = json.decode(response.body);
      final documents = data['documents'] as List;

      // 식당 목록의 아이템들을 각각 Restaurant 객체로 변환 (List<Restaurant>)
      return documents.map((doc) => _mapToRestaurant(doc)).toList();
    } else {
      throw Exception('카카오 API 호출 실패: ${response.statusCode}');
    }
  }

  // 카카오 API 응답 -> Restaurant 모델 변환
  Restaurant _mapToRestaurant(Map<String, dynamic> doc) {
    return Restaurant(
      id: doc['id'], // 카카오 장소 ID
      restaurantName: doc['place_name'],
      district: _extractDistrict(doc['address_name']),
      latitude: double.tryParse(doc['y']),
      longitude: double.tryParse(doc['x']),
    );
  }

  // 주소에서 **구 추출 (예: "서울 영등포구 문래동" → "영등포구")
  String _extractDistrict(String address) {
    final parts = address.split(' ');
    // "구"로 끝나는 부분 찾기
    return parts.firstWhere(
          (part) => part.endsWith('구'),
      orElse: () => '', // "구"로 끝나는 걸 못찾으면 빈 문자열 반환
    );
  }
}