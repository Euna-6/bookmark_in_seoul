import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/kakao_auth_service.dart';

final kakaoAuthServiceProvider = Provider<KakaoAuthService>((ref) {
  return KakaoAuthService();
});

// 현재 로그인한 유저 상태 관리
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(kakaoAuthServiceProvider).authStateChanges;
});