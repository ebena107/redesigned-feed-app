import 'package:feed_estimator/src/utils/widgets/error_widget.dart';
import 'package:feed_estimator/src/utils/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget({
    super.key,
    required this.value,
    required this.data,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const SliverFillRemaining(
        child: AppLoadingWidget(
          message: 'Loading...',
        ),
      ),
      error: (e, st) => SliverFillRemaining(
        child: AppErrorWidget(
          message: 'Error: ${e.toString()}',
          onRetry: null, // No retry mechanism in this context
        ),
      ),
    );
  }
}
