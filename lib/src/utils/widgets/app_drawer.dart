import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/About/about.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';

import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    return Drawer(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: displayHeight(context) * .25,
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    tileMode: TileMode.repeated,
                    stops: [0.6, 0.9],
                    colors: [AppConstants.mainAppColor, Color(0xff67C79F)]),
              ),
              margin: const EdgeInsets.only(bottom: 0),
              currentAccountPicture: const Image(
                image: AssetImage('assets/images/back.png'),
              ),
              accountName: const Text(
                "Feed Estimator",
                style: TextStyle(fontSize: 20),
              ),
              accountEmail: ElevatedButton(
                onPressed: () {
                  context.pop();
                  showDialog<void>(
                    context: context,

                    // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return const About();
                    },
                  );
                },
                child: const Text("About Feed Estimator"),
              ),
            ),
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(40),
          ),
          Expanded(
            flex: 3,
            child: ListView(
              children: [
                Card(
                  //  color: Commons.appBackgroundColor,
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
                          onTap: () async => {
                                context.pop(),
                                ref.read(resultProvider.notifier).resetResult(),
                                ref
                                    .read(ingredientProvider.notifier)
                                    .resetSelections(),
                                await ref
                                    .read(feedProvider.notifier)
                                    .resetProvider(),
                                context.pushNamed('newFeed')
                              }),
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
                        title: const Text("Create Ingredient"),
                        onTap: () {
                          context.pop();
                          //     : context.go('/newIngredient');
                          context.goNamed('newIngredient');
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                        height: 0,
                      ),
                      Card(
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
              child: Card(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      tooltip: "Settings",
                      icon: const Icon(CupertinoIcons.settings),
                    ),
                    IconButton(
                      onPressed: () {},
                      tooltip: "Share Me",
                      icon: const Icon(CupertinoIcons.share_up),
                    ),
                    IconButton(
                      onPressed: () async {},
                      tooltip: "Rate Me",
                      icon: const Icon(CupertinoIcons.star_fill),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
