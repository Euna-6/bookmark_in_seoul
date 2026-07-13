import 'package:bookmark_in_seoul/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bookmark_in_seoul/screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {

  // flutter 프레임워크가 준비될 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  // firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      const ProviderScope(
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}