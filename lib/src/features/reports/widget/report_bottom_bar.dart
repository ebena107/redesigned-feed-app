import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feed_estimator/src/core/constants/common.dart';

class ReportBottomBar extends ConsumerWidget {
  const ReportBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the TOGGLE state, not the navigation index, because we aren't changing routes, just views.
    final bool showIngredients = ref.watch(resultProvider).toggle;
    final bool isDesktop = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.macOS);

    if (isDesktop && !isCompactLayout(context)) {
      return SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 0,
                    icon: Icon(CupertinoIcons.chart_bar_alt_fill),
                    label: Text('Analysis'),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    icon: Icon(CupertinoIcons.list_bullet),
                    label: Text('Ingredients'),
                  ),
                ],
                selected: {showIngredients ? 1 : 0},
                onSelectionChanged: (selection) {
                  ref
                      .read(resultProvider.notifier)
                      .toggle(selection.first == 1);
                },
              ),
            ],
          ),
        ),
      );
    }

    return BottomNavigationBar(
      onTap: (int index) {
        // 0 = Analysis (Toggle False), 1 = Ingredients (Toggle True)
        ref.read(resultProvider.notifier).toggle(index == 1);
      },
      currentIndex: showIngredients ? 1 : 0,
      backgroundColor: Colors.white,
      selectedItemColor: AppConstants.appCarrotColor,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chart_bar_alt_fill),
          label: 'Analysis',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.list_bullet),
          label: 'Ingredients',
        ),
      ],
    );
  }
}
