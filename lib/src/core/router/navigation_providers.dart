import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_providers.freezed.dart';

final appNavigationProvider =
    AutoDisposeStateNotifierProvider<AppNavigationNotifier, AppNavigationState>(
        (ref) {
  return AppNavigationNotifier();
});

@freezed
class AppNavigationState with _$AppNavigationState {
  const factory AppNavigationState({
    @Default(1) int navIndex,
  }) = _AppNavigationState;

  const AppNavigationState._();
}

class AppNavigationNotifier extends StateNotifier<AppNavigationState> {
  AppNavigationNotifier() : super(const AppNavigationState());

  void changeIndex(int index) {
    state = state.copyWith(navIndex: index);
  }
}
