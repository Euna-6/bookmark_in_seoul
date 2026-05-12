import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteDialog({
    required this.onConfirm,
  });

  Widget build(BuildContext context){
    return AlertDialog(
      content: Text("북마크를 해제하시겠습니까?"),
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
          child: const Text("해제"),
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context : context,
      builder : (context) => DeleteDialog(
        onConfirm: onConfirm,
      )
    );
  }

}