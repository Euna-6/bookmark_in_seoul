import 'package:bookmark_in_seoul/model/menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuItem extends StatelessWidget {
  final Menu menu;

  const MenuItem({
    super.key,
    required this.menu
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('###,###,###');
    final String formattedPrice = formatter.format(menu.price);

    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(left:30.0, right:30.0, bottom:30.0,),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(menu.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height:10,),
                  Text("\u20A9${formattedPrice}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width:10),
            Container(
              color: Colors.blue,
              height: 85,
              width: 85,
            ),
          ],
        ),
      ),
    );
  }
}
