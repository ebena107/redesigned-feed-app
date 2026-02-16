import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';

class ResponsiveScaffold extends ConsumerWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  int _selectedIndex(String location) {
    if (location == '/' ||
        location.startsWith('/feed') ||
        location.startsWith('/report')) {
      return 0;
    }
    if (location.startsWith('/newFeed')) return 1;
    if (location.startsWith('/ingredientStore')) return 2;
    if (location.startsWith('/newIngredient')) return 3;
    if (location.startsWith('/feedStore')) return 4;
    if (location.startsWith('/importWizard')) return 5;
    if (location.startsWith('/settings')) return 6;
    return 0;
  }

  void _onDestinationSelected(
    BuildContext context,
    WidgetRef ref,
    int index,
  ) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        ref.read(resultProvider.notifier).resetResult();
        ref.read(ingredientProvider.notifier).resetSelections();
        ref.read(feedProvider.notifier).resetProvider();
        context.go('/newFeed');
        break;
      case 2:
        context.go('/ingredientStore');
        break;
      case 3:
        ref.read(ingredientProvider.notifier).setDefaultValues();
        context.go('/newIngredient');
        break;
      case 4:
        context.go('/feedStore');
        break;
      case 5:
        context.go('/importWizard');
        break;
      case 6:
        context.go('/settings');
        break;
      default:
        context.go('/');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = Scaffold(
      drawer: isCompactLayout(context) ? const FeedAppDrawer() : null,
      backgroundColor: backgroundColor ?? AppConstants.appBackgroundColor,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isCompactLayout(context)) return content;

        final location = GoRouterState.of(context).uri.toString();
        final selectedIndex = _selectedIndex(location);
        final isExtended = constraints.maxWidth >= 1100;

        return Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) =>
                  _onDestinationSelected(context, ref, index),
              extended: isExtended,
              backgroundColor: const Color(0xFFF5F8F6),
              indicatorColor: AppConstants.mainAppColor.withValues(alpha: 0.12),
              leading: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 36,
                        height: 36,
                      ),
                    ),
                    if (isExtended) ...[
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.appTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: Text(context.l10n.navFeeds),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.add_circle_outline),
                  selectedIcon: const Icon(Icons.add_circle),
                  label: Text(context.l10n.homeCreateFeed),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.inventory_2_outlined),
                  selectedIcon: const Icon(Icons.inventory_2),
                  label: Text(context.l10n.screenTitleIngredientLibrary),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.science_outlined),
                  selectedIcon: const Icon(Icons.science),
                  label: Text(context.l10n.customIngredientsTitle),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.storefront_outlined),
                  selectedIcon: const Icon(Icons.storefront),
                  label: Text(context.l10n.feedStoreTitle),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.upload_file_outlined),
                  selectedIcon: const Icon(Icons.upload_file),
                  label: Text(context.l10n.screenTitleImportWizard),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: Text(context.l10n.navSettings),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: content,
            ),
          ],
        );
      },
    );
  }
}
