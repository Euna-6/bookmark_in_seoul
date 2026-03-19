import 'package:bookmark_in_seoul/screen/detail_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:bookmark_in_seoul/screen/home_screen.dart';

import 'model/menu.dart';
import 'model/restaurant.dart';

void main() {
  runApp(
      MaterialApp(
        home: HomeScreen(),
      )
  );
}

class Sample extends StatelessWidget {
  const Sample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailRestaurant(
        restaurant: Restaurant(
          restaurantName: "문뜩",
          district: "영등포구",
          bookmark: 1,
          cntStar: 246548,
          cntHeart: 2448,
          cntCheck: 24648,
          cntX: 48,
          menuList: [
            Menu(name:"맛있는뇨끼엄청맛있는감자뇨끼", price:21000,),
            Menu(name:"로제파스타 크림파스타는 없네 아쉽당", price:18000,),
            Menu(name:"파스타가 있으면 리조또도 있어야지", price:18000,),
            Menu(name:"개인적으로 제로는 좀", price:4000,),
          ]
        ),
      ),
    );
  }
}
