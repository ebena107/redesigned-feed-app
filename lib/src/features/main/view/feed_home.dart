import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';

import 'package:feed_estimator/src/features/main/widget/feed_list.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';

import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainView extends ConsumerWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(asyncMainProvider);
    //debugPrint(data.value.toString());

    return Scaffold(
      drawer: const FeedAppDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 160.0,
            //  leading: IconButton(onPressed: (){}, icon: const Icon(Icons.menu, color: Commons.appBackgroundColor,)),
            actions: [
              FloatingActionButton(
                foregroundColor: AppConstants.mainAppColor,
                backgroundColor: AppConstants.appBackgroundColor,
                child: const Icon(CupertinoIcons.add),
                onPressed: () {
                  ref.read(resultProvider.notifier).resetResult();
                  ref.read(ingredientProvider.notifier).resetSelections();
                  ref.read(feedProvider.notifier).resetProvider();
                  context.pushNamed('newFeed');
                },
              ),
              //   IconButton(
              //     iconSize: 36,
              //     onPressed: () {
              //       ref.read(resultProvider.notifier).resetResult();
              //       ref.read(ingredientProvider.notifier).resetSelections();
              //       ref.read(feedProvider.notifier).resetProvider();
              //       context.pushNamed('newFeed');
              //     },
              //     icon: const Icon(CupertinoIcons.add_circled),
              //     color: AppConstants.appBackgroundColor,
              //   )
            ],
            foregroundColor: AppConstants.appBackgroundColor,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    tileMode: TileMode.repeated,
                    stops: [0.6, 0.9],
                    colors: [AppConstants.mainAppColor, Color(0xff67C79F)]),
              ),
              child: const FlexibleSpaceBar(
                  title: Text('Feed Estimator'),
                  centerTitle: true,
                  background:
                      Image(image: AssetImage('assets/images/back.png'))),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 8,
            ),
          ),
          data.when(
              data: (data) => const FeedList(),
              error: (er, stack) =>
                  SliverFillRemaining(child: Text(er.toString())),
              loading: () =>
                  const SliverFillRemaining(child: CircularProgressIndicator()))
        ],
      ),
      //  floatingActionButton:
    );
  }
}
