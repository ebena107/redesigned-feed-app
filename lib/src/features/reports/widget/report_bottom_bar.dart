import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feed_estimator/src/core/constants/common.dart';

class ReportBottomBar extends ConsumerWidget {
  const ReportBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the TOGGLE state, not the navigation index, because we aren't changing routes, just views.
    final bool showIngredients = ref.watch(resultProvider).toggle;

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
