import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/router/navigation_providers.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/widget/analyse_data_dialog.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widget/estimated_result_widget.dart';
import '../widget/feed_info.dart';
import '../widget/feed_ingredients.dart';

const String _tag = 'NewFeedPage';

class NewFeedPage extends ConsumerWidget {
  final int? feedId;

  const NewFeedPage({
    this.feedId,
    super.key,
  });

  static const routeName = 'newFeed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine if this is an edit or new feed operation
    // feedId of null, 0, or 9999 indicates a new feed
    final isEdit = feedId != null && feedId != 0 && feedId != 9999;
    final id = isEdit ? feedId : null;
    final title = isEdit ? "Update Feed" : "Add/Check Feed";

    AppLogger.debug('NewFeedPage - isEdit: $isEdit, id: $id', tag: _tag);
    return Scaffold(
      drawer: const FeedAppDrawer(),
      backgroundColor: AppConstants.appBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            backgroundColor: isEdit
                ? AppConstants.appCarrotColor
                : AppConstants.appBlueColor,
            expandedHeight: displayHeight(context) * .25,
            // Extend app bar color into status bar
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: isEdit
                  ? AppConstants.appCarrotColor
                  : AppConstants.appBlueColor,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            //  title: feedId == null ? Text("Set New Feed") : Text("Update Feed"),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  tileMode: TileMode.repeated,
                  stops: const [0.6, 0.9],
                  colors: isEdit
                      ? [const Color(0xffff6f00), Colors.deepOrange]
                      : [Colors.blue, const Color(0xff2962ff)],
                ),
              ),
              child: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                    // style: titleTextStyle(),
                  ),
                  background:
                      const Image(image: AssetImage('assets/images/back.png'))),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: displayHeight(context) * .05),
              child: FeedInfo(feedId: id),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer(
              builder: (context, WidgetRef ref, child) {
                final data = ref.watch(resultProvider).myResult;
                return data != null
                    ? data.mEnergy != null
                        ? SizedBox(
                            child: ResultEstimateCard(data: data, feedId: id))
                        : const SizedBox()
                    : const SizedBox();
              },
            ),
          ),
          const SliverFillRemaining(
            fillOverscroll: true,
            child: FeedIngredientsField(),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomBar(
        isEdit: isEdit,
        feedId: id,
      ),
    );
  }
}

Widget buildBottomBar({int? feedId, required bool isEdit}) {
  return Consumer(builder: (context, ref, child) {
    return BottomNavigationBar(
      onTap: (int index) {
        ref.read(appNavigationProvider.notifier).changeIndex(index);
        _onItemTapped(index, context, ref, feedId, isEdit);
      },
      backgroundColor: AppConstants.appBackgroundColor,
      currentIndex: 1,
      elevation: UIConstants.cardElevation,
      type: BottomNavigationBarType.fixed,
      selectedItemColor:
          isEdit ? AppConstants.appCarrotColor : AppConstants.appBlueColor,
      iconSize: UIConstants.iconLarge,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.cart_badge_plus),
          label: 'Add Ingredients',
          tooltip: 'Add more ingredients to feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            isEdit ? Icons.update : CupertinoIcons.floppy_disk,
          ),
          label: isEdit ? 'Update' : 'Save',
          tooltip: isEdit ? 'Update feed' : 'Save feed',
        ),
        const BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.forward_end_alt),
          label: 'Analyse',
          tooltip: 'Analyse feed composition',
        ),
      ],
    );
  });
}

Future<void> _onItemTapped(
  int index,
  BuildContext context,
  WidgetRef ref,
  int? feedId,
  bool isEdit,
) async {
  final feedState = ref.read(feedProvider);
  final feedName = feedState.feedName.trim();
  final ingredients = feedState.feedIngredients;

  AppLogger.debug('Bottom nav tapped: index=$index, isEdit=$isEdit', tag: _tag);

  try {
    switch (index) {
      case 0: // Add ingredients
        if (isEdit) {
          ref.read(ingredientProvider.notifier).loadFeedExistingIngredients();
          context.go('/feed/$feedId/feedIngredient');
        } else {
          context.go(
              '/newFeed/ingredientList${feedId != null ? '?feed-id=$feedId' : ''}');
        }
        break;

      case 1: // Save/Update
        if (feedName.isEmpty) {
          _showErrorSnackBar(
            context: context,
            title: 'Feed Name Required',
            message: 'Please enter a name for your feed before saving.',
          );
          AppLogger.warning('Save attempted without feed name', tag: _tag);
          return;
        }

        final todo = isEdit ? "update" : "save";
        await ref.read(asyncMainProvider.notifier).saveUpdateFeed(
              todo: todo,
              onSuccess: (response) {
                if (!context.mounted) return;
                final message = ref.read(feedProvider).message;
                final isSuccess = response.toLowerCase() == 'success';
                if (isSuccess) {
                  _showSuccessSnackBar(
                    context: context,
                    title: message,
                    shouldPopPage: true,
                  );
                } else {
                  _showErrorSnackBar(
                    context: context,
                    title: message,
                  );
                }
              },
            );
        break;

      case 2: // Analyse
        // Validate feed data
        if (feedName.isEmpty) {
          _showErrorSnackBar(
            context: context,
            title: 'Missing Feed Name',
            message: 'Please enter a feed name before analysing.',
          );
          return;
        }

        if (ingredients.isEmpty) {
          _showErrorSnackBar(
            context: context,
            title: 'No Ingredients',
            message: 'Please add at least one ingredient to analyse.',
          );
          return;
        }

        if (ingredients.any((e) => e.quantity == null || e.quantity == 0.0)) {
          _showErrorSnackBar(
            context: context,
            title: 'Invalid Quantities',
            message:
                'All ingredients must have valid quantities greater than 0.',
          );
          return;
        }

        // Show analyse dialog
        _showAnalyseDialog(context, feedId);
        break;

      default:
        AppLogger.warning('Unknown bottom nav index: $index', tag: _tag);
    }
  } catch (e, stackTrace) {
    AppLogger.error('Error in bottom nav action: $e',
        tag: _tag, error: e, stackTrace: stackTrace);
    if (!context.mounted) return;
    _showErrorSnackBar(
      context: context,
      title: 'An Error Occurred',
      message: 'Please try again.',
    );
  }
}

/// Show error SnackBar with Material Design 3 styling
void _showErrorSnackBar({
  required BuildContext context,
  required String title,
  String? message,
}) {
  final fullMessage = message != null ? '$title: $message' : title;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fullMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red[600],
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.fixed,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}

/// Show success SnackBar with automatic page navigation
void _showSuccessSnackBar({
  required BuildContext context,
  required String title,
  String? message,
  bool shouldPopPage = false,
}) {
  final fullMessage = message != null ? '$title: $message' : title;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fullMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green[600],
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
    ),
  );

  if (shouldPopPage) {
    // Navigate back to feed list on success after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }
}

/// Show analyse confirmation dialog
void _showAnalyseDialog(BuildContext context, int? feedId) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AnalyseDataDialog(
      parentContext: context, // Pass parent context for navigation
      feedId: feedId,
    ),
  );
}
