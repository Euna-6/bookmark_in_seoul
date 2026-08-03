import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void start() => state = true;  // 로딩 시작
  void end() => state = false;   // 로딩 끝
}

final isLoadingProvider = NotifierProvider<LoadingNotifier, bool>(
      () => LoadingNotifier(),
);