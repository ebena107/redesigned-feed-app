import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';

import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

// final _availablePages = <String, WidgetBuilder>{
//   'Feeds Page': (_) => FeedHome(),
//   'New Feed' : (_) =>NewFeedPage(),
// };

class FeedAppDrawer extends ConsumerWidget {
  const FeedAppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InAppReview inAppReview = InAppReview.instance;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          const SystemUiOverlayStyle(statusBarColor: AppConstants.mainAppColor),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Drawer(
            child: Container(
          padding: const EdgeInsets.all(0.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              //  topRight: Radius.elliptical(50, 50),
              bottomRight: Radius.elliptical(50, 50),
            ),
            color: Colors.transparent,
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.repeated,
                stops: [0.6, 0.9],
                colors: [AppConstants.mainAppColor, Color(0xff67C79F)]),
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                color: AppConstants.appBackgroundColor,
                offset: Offset(0, 3.5),
              )
            ],
          ),
          child: Column(
            children: [
              // Container(
              //   margin: const EdgeInsets.only(bottom: 16),
              //   height: displayHeight(context) * .25,
              //   child: UserAccountsDrawerHeader(
              //     decoration: const BoxDecoration(
              //       gradient: LinearGradient(
              //           begin: Alignment.bottomLeft,
              //           end: Alignment.topRight,
              //           tileMode: TileMode.repeated,
              //           stops: [0.6, 0.9],
              //           colors: [AppConstants.mainAppColor, Color(0xff67C79F)]),
              //     ),
              //     margin: const EdgeInsets.only(bottom: 0),
              //     currentAccountPicture: const Image(
              //       image: AssetImage('assets/images/back.png'),
              //     ),
              //     accountName: const Text(
              //       "Feed Estimator",
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     accountEmail: ElevatedButton(
              //       onPressed: () {
              //         context.pop();
              //         showDialog<void>(
              //           context: context,
              //
              //           // false = user must tap button, true = tap outside dialog
              //           builder: (BuildContext dialogContext) {
              //             return const About();
              //           },
              //         );
              //       },
              //       child: const Text("About Feed Estimator"),
              //     ),
              //   ),
              // ),
              // SizedBox.fromSize(
              //   size: const Size.fromHeight(40),
              // ),
              Expanded(
                flex: 6,
                child: ListView(
                  children: [
                    _createMenuHeader(),
                    SizedBox(
                      height: displayHeight(context) * .1,
                    ),
                    Card(
                      color: AppConstants.appBackgroundColor,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                              leading: const Icon(CupertinoIcons.home),
                              trailing: const Icon(CupertinoIcons.forward),
                              dense: true,
                              title: const Text("Feeds"),
                              onTap: () => {context.pop(), context.push('/')}),
                          const Divider(
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                            height: 0,
                          ),
                          ListTile(
                            leading: const Icon(CupertinoIcons.add_circled),
                            trailing: const Icon(CupertinoIcons.forward),
                            dense: true,
                            title: const Text("Add New Feed"),
                            onTap: () => {
                              context.pop(),
                              ref.read(resultProvider.notifier).resetResult(),
                              ref
                                  .read(ingredientProvider.notifier)
                                  .resetSelections(),
                              ref.read(feedProvider.notifier).resetProvider(),
                              const AddFeedRoute().go(context),
                            },
                          ),
                          const Divider(
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                            height: 0,
                          ),
                          ListTile(
                            leading: const Icon(CupertinoIcons.create),
                            trailing: const Icon(CupertinoIcons.forward),
                            dense: true,
                            title: const Text("Create Custom Ingredient"),
                            onTap: () {
                              context.pop();
                              ref
                                  .read(ingredientProvider.notifier)
                                  .setDefaultValues();
                              context.pushNamed('newIngredient');
                            },
                          ),
                          const Divider(
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                            height: 0,
                          ),
                          Card(
                            color: AppConstants.appBackgroundColor,
                            child: Column(
                              children: [
                                SizedBox.fromSize(
                                  size: const Size.fromHeight(20),
                                ),
                                Text(
                                  'Store Manager',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.appCarrotColor),
                                ),
                                SizedBox.fromSize(
                                  size: const Size.fromHeight(10),
                                ),
                                const Divider(
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  height: 0,
                                ),
                                // ListTile(
                                //   leading: const Icon(
                                //       CupertinoIcons.pencil_ellipsis_rectangle),
                                //   trailing: const Icon(CupertinoIcons.forward),
                                //   dense: true,
                                //   title: const Text("Update Stored Feed"),
                                //   onTap: () {
                                //     context.pop();
                                //     //     : context.go('/newIngredient');
                                //     context.pushNamed('feedStore');
                                //   },
                                // ),
                                const Divider(
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  height: 0,
                                ),
                                ListTile(
                                  leading: const Icon(
                                      CupertinoIcons.pencil_ellipsis_rectangle),
                                  trailing: const Icon(CupertinoIcons.forward),
                                  dense: true,
                                  title: const Text("Update Ingredients"),
                                  onTap: () {
                                    context.pop();
                                    //     : context.go('/newIngredient');
                                    context.pushNamed('ingredientStore');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        //  topRight: Radius.elliptical(50, 50),
                        bottomRight: Radius.elliptical(50, 50),
                      ),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          color: AppConstants.appBackgroundColor,
                          offset: Offset(0, 3.5),
                        )
                      ],
                    ),
                    margin: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () async {
                        inAppReview.openStoreListing();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Rate Me"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.star_fill,
                                color: AppConstants.appCarrotColor,
                              ),
                              Icon(
                                CupertinoIcons.star_fill,
                                color: AppConstants.appCarrotColor,
                              ),
                              Icon(
                                CupertinoIcons.star_fill,
                                color: AppConstants.appCarrotColor,
                              ),
                              Icon(
                                CupertinoIcons.star_fill,
                                color: AppConstants.appCarrotColor,
                              ),
                              Icon(
                                CupertinoIcons.star_fill,
                                color: AppConstants.appCarrotColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

Widget _createMenuHeader() {
  return UserAccountsDrawerHeader(
    decoration: const BoxDecoration(color: AppConstants.mainAppColor),
    margin: EdgeInsets.zero,
    accountName: Text(
      'Feed Estimator',
      style: headlineTextStyle(),
      textAlign: TextAlign.center,
    ),
    accountEmail: FutureBuilder(
      future: getVersionNumber(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) => Text(
        snapshot.hasData ? snapshot.data as String : "Loading ...",
        //'loading...'
//                style: TextStyle(color: Colors.black38),
      ),
    ),
    currentAccountPicture: CircleAvatar(
        child: Image(
      image: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.scaleDown,
      ).image,
    )),
  );
}

Future<String> getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  String appDetail = '$version +$buildNumber';

  return appDetail;

  // return '0.1.0';
}
