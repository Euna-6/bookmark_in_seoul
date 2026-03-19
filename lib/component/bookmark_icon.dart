import 'package:flutter/material.dart';

class BookmarkIcon extends StatefulWidget {
  final int bookmark;
  final double size;
  final bool isBookmarked;

  const BookmarkIcon({
    super.key,
    required this.bookmark,
    this.size = 22.0,
    this.isBookmarked = false,
  });

  @override
  State<BookmarkIcon> createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {
  @override
  Widget build(BuildContext context) {
    // bookmark==0 은 항상 같은 아이콘을 유지한다
    if(widget.bookmark==0){
      return Icon(
        Icons.bookmark_border,
        color: const Color(0xFFCFCFCF),
        size: widget.size,
      );
    }

    switch (widget.bookmark) {
      case 1 :
        return Icon(
          widget.isBookmarked? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: widget.size,
        );
      case 2 :
        return Icon(
          widget.isBookmarked? Icons.favorite : Icons.favorite_border,
          color: Colors.redAccent,
          size: widget.size,
        );
      case 3 :
        return Icon(
          widget.isBookmarked? Icons.check_circle_outline : Icons.check_circle_outline,
          color: Colors.blueGrey,
          size: widget.size,
        );
      case 4 :
        return Icon(
          widget.isBookmarked? Icons.thumb_down_off_alt_outlined : Icons.thumb_down_off_alt_outlined,
          color: Colors.grey,
          size: widget.size,
        );
      default :
        return Icon(
          Icons.bookmark_border,
          color: const Color(0xFFCFCFCF),
          size: widget.size,
        );
    }

  }
}
