import 'package:bookmark_in_seoul/firebase_options.dart';
import 'package:bookmark_in_seoul/providers/auth_provider.dart';
import 'package:bookmark_in_seoul/screen/login_screen.dart';
import 'package:bookmark_in_seoul/service/kakao_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bookmark_in_seoul/screen/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {

  // flutter 프레임워크가 준비될 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일을 사용하기 위해 가져오는 작업
  await dotenv.load(fileName: "assets/.env");

  // firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 카카오 로그인 : runApp() 호출 전 Flutter SDK 초기화
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: dotenv.env['MY_NATIVE_APP_KEY'],
  );

  // 유저 유효성 확인
  final authService = KakaoAuthService();
  final isValid = await authService.checkUserValid();

  runApp(
      ProviderScope(
        child: MyApp(isValid: isValid),
      )
  );
}

class MyApp extends ConsumerWidget {
  final bool isValid;
  const MyApp({super.key, required this.isValid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      home: authState.when(
        data: (user) {
          // 로그인 상태면 메인화면, 아니면 로그인 화면
          // isValid == false 면 Firebase에 유저가 존재했는데 삭제된 경우
          // user==null 면 애초에 로그인을 안한 경우
          if(!isValid || user == null) return LoginScreen();
          return HomeScreen();
        },
        loading: () =>
        const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => LoginScreen(),
      ),
    );
  }
}