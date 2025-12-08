import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_providers.freezed.dart';

final appNavigationProvider =
    NotifierProvider<AppNavigationNotifier, AppNavigationState>(
        AppNavigationNotifier.new);

// ignore: use_to_and_then
@freezed
class AppNavigationState with _$AppNavigationState {
  const factory AppNavigationState({
    @Default(1) int navIndex,
  }) = _AppNavigationState;

  const AppNavigationState._();
}

class AppNavigationNotifier extends Notifier<AppNavigationState> {
  @override
  AppNavigationState build() {
    return const AppNavigationState();
  }

  void changeIndex(int index) {
    state = state.copyWith(navIndex: index);
  }
}
