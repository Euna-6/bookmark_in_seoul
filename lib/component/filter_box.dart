import 'package:flutter/material.dart';

class FilterBox extends StatelessWidget {
  const FilterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: 16,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(16.0),
            child:
            Row(
              children: [
                SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('지역'),
                      SizedBox(height:10,),
                      Text('영등포구',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('정렬'),
                      SizedBox(height:10,),
                      Text('별',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width:16,),
      ],
    );
  }
}
