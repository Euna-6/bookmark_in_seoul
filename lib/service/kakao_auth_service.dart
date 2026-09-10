import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' hide User;

class KakaoAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 카카오 로그인
  Future<UserCredential?> signInWithKakao() async {
    try {
      // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
      OAuthToken token = await isKakaoTalkInstalled()
        ? await UserApi.instance.loginWithKakaoTalk()
          : await await UserApi.instance.loginWithKakaoAccount();
      print('[kakaoAuthService] 카카오로그인 성공 ${token.accessToken}');

      // Firebase OIDC로 연동
      final credential = OAuthProvider('oidc.kakao').credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );

      return await _auth.signInWithCredential(credential);

    } catch (e) {
      print('[kakaoAuthService] 카카오 로그인 실패: $e');
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await UserApi.instance.logout();
      await _auth.signOut();
    } catch (e) {
      print('[kakaoAuthService] 로그아웃 실패 $e');
    }

  }

  Future<bool> checkUserValid() async {
    try {
      final user = _auth.currentUser;
      if (user==null) return false;

      await user.getIdToken(true);
      return true;
    } catch(e) {
      // 유저가 삭제됐거나 토큰이 유효하지 않을때
      await signOut();
      return false;
    }
  }

  // 현재 로그인 상태 확인
  User? get currentUser => _auth.currentUser;

  // 자동 로그인 여부 확인
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}