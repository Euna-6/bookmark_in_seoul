import 'package:flutter/material.dart';

class IsbookmarkDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  // my_bookmark.dart에서는 사용하지 않기에 nullable
  final int? selectedIcon; // 설정되어있던 아이콘
  final int? tappedIcon;   // 지금 누른 아이콘

  const IsbookmarkDialog({
    required this.onConfirm,
    this.selectedIcon,
    this.tappedIcon,
  });

  bool get _isNew => selectedIcon == null || selectedIcon == 0;
  bool get _isSame => selectedIcon == tappedIcon;

  Widget build(BuildContext context){
    return AlertDialog(
      content: Text(
        _isNew
        ? "북마크를 설정하시겠습니까?"
        : _isSame
          ? "북마크를 해제하시겠습니까?"
            : "북마크를 변경하시겠습니까",
      ),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.pop(context),
          child: const Text("취소"),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: Text(
            _isNew
                ? "설정"
                : _isSame
              ? "해제"
              : "변경",
          ),
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onConfirm,
    int? selectedIcon,
    int? tappedIcon,
  }) {
    return showDialog<void>(
      context : context,
      builder : (context) => IsbookmarkDialog(
        selectedIcon: selectedIcon,
        tappedIcon: tappedIcon,
        onConfirm: onConfirm,
      )
    );
  }

}