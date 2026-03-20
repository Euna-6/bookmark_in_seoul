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

/*
class _BookmarkIconState extends State<BookmarkIcon> {
  @override
  Widget build(BuildContext context) {
    switch (widget.bookmark) {
      case 1:
        return _iconBtnStyle(
          icon: Icon(
            widget.isBookmarked? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: widget.size,
          ),
          onTap: () {
          },
        );
      case 2:
        return _iconBtnStyle(
          icon: Icon(
            widget.isBookmarked ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
            size: widget.size,
          ),
          onTap: () {
            setState(() {
              widget.isBookmarked = !widget.isBookmarked;
            });
          },
        );
      case 3:
        return _iconBtnStyle(
          icon: Icon(
            Icons.check_circle_outline,
            color: widget.isBookmarked ? Colors.green : Colors.blueGrey[600],
            size: widget.size,
          ),
          onTap: () {
            setState(() {
              widget.isBookmarked = !widget.isBookmarked;
            });
          },
        );
      case 4:
        return _iconBtnStyle(
          icon: Icon(
            Icons.thumb_down_off_alt_outlined,
            color: widget.isBookmarked ? Colors.black : Colors.grey,
            size: widget.size,
          ),
          onTap: () {
            setState(() {
              widget.isBookmarked = !widget.isBookmarked;
            });
          },
        );
      default:
        return Icon(
          Icons.bookmark_border,
          color: const Color(0xFFCFCFCF),
          size: widget.size,
        );
    }
  }
}

 */

// IconButton UI
class _iconBtnStyle extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;

  const _iconBtnStyle({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
      ),
      icon: icon,
      onPressed: onTap,
    );
  }
}
