import 'package:bookmark_in_seoul/screen/detail_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:bookmark_in_seoul/screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/menu.dart';
import 'model/restaurant.dart';

void main() {
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