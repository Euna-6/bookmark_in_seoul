import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고
            Image.asset(
              'assets/icon/icon.png',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 32),
            Text(
              '로그인 한 번으로\n서울 맛집을 탐방해보세요!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12,),
            // 카카오 로그인 버튼
            GestureDetector(
              onTap: () async {
                final authService = ref.read(kakaoAuthServiceProvider);
                final result = await authService.signInWithKakao();

                if (result != null) {
                  // 로그인 성공 시, 메인화면으로
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  // 로그인 실패
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('로그인에 실패했어요. 다시 시도해주세요.')),
                  );
                }
              },
              child: Image.asset(
                'assets/icon/kakao_login_button.png',  // 카카오 로그인 버튼 이미지
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}