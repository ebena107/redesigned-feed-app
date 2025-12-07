import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/navigation_providers.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
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
import 'package:quickalert/quickalert.dart';

import '../widget/estimated_result_widget.dart';
import '../widget/feed_info.dart';
import '../widget/feed_ingredients.dart';

class NewFeedPage extends ConsumerWidget {
  final int? feedId;

  const NewFeedPage({
    this.feedId,
    super.key,
  });

  static const routeName = 'newFeed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String title;
    bool isEdit;
    int? id;

    isEdit = feedId == null || feedId == 9999 || feedId == 0 ? false : true;

    id = feedId == null || feedId == 9999 || feedId == 0 ? null : feedId;

    title = isEdit ? "Update Feed" : "Add/Check Feed";

    //debugPrint(' newFeed - id: $id and feedId: $feedId  and title: $title');
    // String title = id == null ? "Add/Check Feed" : "Update Feed";
    //int? feedId = id != null ? int.parse(id!): null;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              // systemNavigationBarColor: Colors.blue, // Navigation bar
              statusBarColor: isEdit
                  ? AppConstants.appCarrotColor
                  : AppConstants.appBlueColor, // Status bar
            ),
          ),
        ),
        drawer: const FeedAppDrawer(),
        backgroundColor: AppConstants.appBackgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: true,
              //  automaticallyImplyLeading: false,
              backgroundColor: isEdit
                  ? AppConstants.appCarrotColor
                  : AppConstants.appBlueColor,
              expandedHeight: displayHeight(context) * .25,
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
                      // style: titleTextStyle(),
                    ),
                    background: const Image(
                        image: AssetImage('assets/images/back.png'))),
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
      ),
    );
  }
}

Widget buildBottomBar({int? feedId, required bool isEdit}) {
  return Consumer(builder: (context, ref, child) {
    // final currentIndex = ref.watch(appNavigationProvider).navIndex;

    return BottomNavigationBar(
        onTap: (int index) {
          ref.read(appNavigationProvider.notifier).changeIndex(index);
          _onItemTapped(
            index,
            context,
            ref,
            feedId,
            isEdit,
          );
        },
        backgroundColor: AppConstants.appBackgroundColor,
        currentIndex: 1,
        elevation: 0,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart_badge_plus),
            label: 'Add More Ingredient',
            backgroundColor: AppConstants.appCarrotColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isEdit ? Icons.update : CupertinoIcons.floppy_disk,
              color: isEdit ? AppConstants.appCarrotColor : Colors.blue,
            ),
            label: isEdit ? 'Update' : 'Save',
          ),
          const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.forward_end_alt), label: 'Analyse'),
          //  BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
        ]);
  });
}

Future<void> _onItemTapped(int index, BuildContext context, WidgetRef ref,
    int? feedId, bool isEdit) async {
  final name = ref.watch(feedProvider).feedName;
  String todo = isEdit ? "update" : "save";
  var mMessage = ref.watch(feedProvider).message;
  var status = ref.watch(feedProvider).status;

  switch (index) {
    case 0:
      isEdit
          ? ref.read(ingredientProvider.notifier).loadFeedExistingIngredients()
          : '';
      isEdit
          ? FeedIngredientsRoute(feedId!).go(context)
          : NewFeedIngredientsRoute(feedId).go(context);
      break;
    case 1:
      name == ""
          ? {
              status = "info",
              mMessage = "Feed Name is Compulsory",
              handleAlert(type: status, context: context, title: mMessage),
            }
          : ref.read(asyncMainProvider.notifier).saveUpdateFeed(
              todo: todo,
              onSuccess: (response) => handleAlert(
                  type: response, context: context, title: mMessage));
      // handleMessage();

      //   messageHandlerWidget(context: context, message: mMessage, type: status);
      //  status == "success" ? ref.read(routerProvider).go('/') : '';
      break;
    case 2:
      final ing = ref.watch(feedProvider).feedIngredients;
      name == "" ||
              (ing.isEmpty ||
                  ing.any((e) => e.quantity == 0.0) ||
                  ing.any((e) => e.quantity == null))
          ? {
              status = "failure",
              mMessage = "Enter all feed details : Name and ingredients",
              // handleMessage()
              // messageHandlerWidget(
              //     context: context, message: mMessage, type: status)
              handleAlert(type: status, context: context, title: mMessage)
            }
          : Navigator.of(context)
              .restorablePush(analyseDialogBuilder, arguments: feedId);

      break;
  }
}

Future<dynamic> handleAlert(
    {required String type,
    required BuildContext context,
    required String title}) {
  // String title = "";
  QuickAlertType myType = QuickAlertType.info;

  switch (type) {
    case 'success':
      myType = QuickAlertType.success;
      //title = 'successfully saved';
      context.pop();
      break;
    case 'failure':
      myType = QuickAlertType.error;
      //  title = 'failed to save';
      break;
    case 'warning':
      myType = QuickAlertType.warning;
      //   title = 'checked to save';
      break;
  }

  return QuickAlert.show(context: context, type: myType, title: title);
}

Route<Object?> analyseDialogBuilder(
  BuildContext context,
  Object? arguments,
) {
  int? feedId = arguments != null ? arguments as int : null;

  return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AnalyseDataDialog(feedId: feedId));
}
