import 'package:flutter/material.dart';

class BookmarkIcon extends StatelessWidget {
  final int bookmark; // 1~4
  final double size;
  final bool isBookmarked;
  final VoidCallback onTap;

  const BookmarkIcon({
    super.key,
    required this.bookmark,
    this.size = 25.0,
    this.isBookmarked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    IconData getIconData(int bookmark){
      switch(bookmark){
        case 1 : return isBookmarked? Icons.star : Icons.star_border;
        case 2 : return isBookmarked? Icons.favorite : Icons.favorite_border;
        case 3 : return Icons.check_circle_outline;
        case 4 : return Icons.thumb_down_off_alt_outlined;
        default : return Icons.bookmark_border;
      }
    }

    Color getIconColor(int bookmark){
      switch(bookmark){
        case 1 : return Colors.amber;
        case 2 : return Colors.redAccent;
        case 3 : return isBookmarked? Colors.green : Colors.blueGrey;
        case 4 : return isBookmarked? Colors.black : Colors.grey;
        default : return Colors.grey;
      }
    }

    return IconButton(
        onPressed: onTap,
        icon: Icon(
          getIconData(bookmark),
          color: getIconColor(bookmark),
          size: size,
        ),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
      ),
    );
  }
}