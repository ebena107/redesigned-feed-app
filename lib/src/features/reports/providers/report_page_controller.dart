import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../add_update_feed/providers/feed_provider.dart';

part 'report_page_controller.g.dart';

@riverpod
class ReportPageController extends _$ReportPageController {
  @override
  FutureOr<void> build() async {
    fetchResult();
//
  }

  Future<void> fetchResult() async {
    final feeds = ref.read(feedProvider);
    final results = ref.read(resultProvider.notifier);

    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => results.estimatedResult(feed: feeds.newFeed));
  }
}
