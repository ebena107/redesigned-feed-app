import 'package:flutter_riverpod/flutter_riverpod.dart';

final appNavigationProvider =
    NotifierProvider<AppNavigationNotifier, AppNavigationState>(
        AppNavigationNotifier.new);

sealed class AppNavigationState {
  const AppNavigationState({this.navIndex = 1});

  final int navIndex;

  AppNavigationState copyWith({int? navIndex}) =>
      _AppNavigationState(navIndex: navIndex ?? this.navIndex);
}

class _AppNavigationState extends AppNavigationState {
  const _AppNavigationState({super.navIndex = 1});
}

class AppNavigationNotifier extends Notifier<AppNavigationState> {
  @override
  AppNavigationState build() {
    return const _AppNavigationState();
  }

  void changeIndex(int index) {
    state = state.copyWith(navIndex: index);
  }
}
