import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FeedAppDrawer extends ConsumerWidget {
  const FeedAppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.toString();
    const background = Color(0xFFF5F8F6);
    final borderColor = AppConstants.mainAppColor.withValues(alpha: 0.08);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
        ),
        backgroundColor: background,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _DrawerHeader(borderColor: borderColor),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    const _SectionLabel(text: 'NAVIGATION'),
                    const SizedBox(height: 6),
                    _DrawerTile(
                      icon: Icons.home_outlined,
                      title: 'Feeds',
                      subtitle: 'View and manage feed formulations',
                      selected: location == '/' || location.startsWith('/feed'),
                      onTap: () {
                        context.pop();
                        context.go('/');
                      },
                    ),
                    const SizedBox(height: 8),
                    _DrawerTile(
                      icon: Icons.add_circle_outline,
                      title: 'Add New Feed',
                      subtitle: 'Create a new feed formulation',
                      selected: location.startsWith('/newFeed'),
                      onTap: () {
                        context.pop();
                        ref.read(resultProvider.notifier).resetResult();
                        ref.read(ingredientProvider.notifier).resetSelections();
                        ref.read(feedProvider.notifier).resetProvider();
                        const AddFeedRoute().go(context);
                      },
                    ),
                    const SizedBox(height: 14),
                    const _SectionLabel(text: 'INGREDIENTS'),
                    const SizedBox(height: 6),
                    _DrawerTile(
                      icon: Icons.inventory_2_outlined,
                      title: 'Ingredient Library',
                      subtitle: 'Browse and manage all ingredients',
                      selected: location.startsWith('/ingredientStore'),
                      onTap: () {
                        context.pop();
                        const IngredientStoreRoute().go(context);
                      },
                    ),
                    const SizedBox(height: 8),
                    _DrawerTile(
                      icon: Icons.science_outlined,
                      title: 'Create Custom Ingredient',
                      subtitle: 'Add a new ingredient to your library',
                      selected: location.startsWith('/newIngredient'),
                      onTap: () {
                        context.pop();
                        ref
                            .read(ingredientProvider.notifier)
                            .setDefaultValues();
                        const NewIngredientRoute().go(context);
                      },
                    ),
                    const SizedBox(height: 14),
                    // const _SectionLabel(text: 'SETTINGS'),
                    // const SizedBox(height: 6),
                    // _DrawerTile(
                    //   icon: Icons.settings_outlined,
                    //   title: 'Settings',
                    //   subtitle: 'Privacy, data, and app preferences',
                    //   selected: location.startsWith('/settings'),
                    //   onTap: () {
                    //     context.pop();
                    //     const SettingsRoute().go(context);
                    //   },
                    // ),
                    // const SizedBox(height: 18),
                    // _VersionTile(borderColor: borderColor),
                    // const SizedBox(height: 12),
                  ],
                ),
              ),
              const _SectionLabel(text: 'SETTINGS'),
              const SizedBox(height: 6),
              _DrawerTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Privacy, data, and app preferences',
                selected: location.startsWith('/settings'),
                onTap: () {
                  context.pop();
                  const SettingsRoute().go(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.borderColor});

  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppConstants.mainAppColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feed Estimator',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: const Color(0xFF123524),
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<String>(
                  future: getVersionNumber(),
                  builder: (context, snapshot) {
                    final value = snapshot.data ?? '...';
                    return Text(
                      'Version $value',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.grey.shade700,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.selected = false,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const Color accent = AppConstants.mainAppColor;
    final Color base = selected ? accent.withValues(alpha: 0.08) : Colors.white;

    return Material(
      color: base,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF123524),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF9E9E9E),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 0.8,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _VersionTile extends StatelessWidget {
  const _VersionTile({required this.borderColor});

  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppConstants.appCarrotColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.verified_outlined,
                color: AppConstants.appCarrotColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FutureBuilder<String>(
              future: getVersionNumber(),
              builder: (context, snapshot) {
                final value = snapshot.data ?? '...';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Version',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF123524),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> getVersionNumber() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.version;
  final buildNumber = packageInfo.buildNumber;
  final appDetail = '$version+$buildNumber';

  return appDetail;
}
