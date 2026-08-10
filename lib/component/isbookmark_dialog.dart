import 'package:flutter/material.dart';

class IsbookmarkDialog extends StatefulWidget {
  final Function(String? memo) onConfirm;
  // my_bookmark.dart에서는 사용하지 않기에 nullable
  final int? selectedIcon; // 설정되어있던 아이콘
  final int? tappedIcon;   // 지금 누른 아이콘
  final String? myMemo;    // 메모

  const IsbookmarkDialog({
    required this.onConfirm,
    this.selectedIcon,
    this.tappedIcon,
    this.myMemo,
  });

  bool get _isNew => selectedIcon == null || selectedIcon == 0;
  bool get _isSame => selectedIcon == tappedIcon;

  @override
  State<IsbookmarkDialog> createState() => _IsbookmarkDialogState();

  static Future<void> show({
    required BuildContext context,
    required Function(String? memo) onConfirm,
    int? selectedIcon,
    int? tappedIcon,
    String? myMemo,
  }) {
    return showDialog<void>(
        context : context,
        builder : (context) => IsbookmarkDialog(
          selectedIcon: selectedIcon,
          tappedIcon: tappedIcon,
          onConfirm: onConfirm,
          myMemo: myMemo,
        )
    );
  }

}

class _IsbookmarkDialogState extends State<IsbookmarkDialog> {
  late TextEditingController _memoController;

  // 메모가 존재하면 보여주기
  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.myMemo);
  }

  // Controller dispose 안해주면 다른 화면으로 넘어가도 running
  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget._isNew
              ? "북마크를 설정하시겠습니까?"
              : widget._isSame
                ? "북마크를 해제하시겠습니까?"
                  : "북마크를 변경하시겠습니까?",
              textAlign: TextAlign.center,
            ),
            if(widget._isSame)
              Text('메모도 함께 삭제됩니다!\n(메모 수정은 상세화면에서 가능)',
              style: TextStyle(color: Colors.black45, fontSize: 12),
              textAlign: TextAlign.center,)
            else
              Padding(
                padding: const EdgeInsets.only(top:12),
                child: TextField(
                  controller: _memoController,
                  decoration: InputDecoration(
                    hintText: '메모를 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 12),
                  maxLines: 3,
                  maxLength: 66,
                ),
              )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.pop(context),
          child: const Text("취소"),
        ),
        TextButton(
          onPressed: () {
            // 메모 값 넘겨주기
            final memo = widget._isSame
              ? null
              : _memoController.text.isEmpty
                ? null
                : _memoController.text;
            print("[isbookmarkDialog] memo = ${memo}");
            widget.onConfirm(memo);
            Navigator.pop(context);
          },
          child: Text(
            widget._isNew
                ? "설정"
                : widget._isSame
              ? "해제"
              : "변경",
          ),
        ),
      ],
    );
  }
}