import 'package:feed_estimator/src/core/constants/common.dart';

import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class StoredFeeds extends StatelessWidget {
  const StoredFeeds({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FeedAppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          tileMode: TileMode.repeated,
          stops: [0.4, 0.8],
          colors: [
            AppConstants.appBackgroundColor,
            Color(0xff87643E),
          ],
        )),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: displayHeight(context) * .25,
              //  leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu, color: AppConstants.appBackgroundColor,)),
              actions: const [],
              foregroundColor: AppConstants.appBackgroundColor,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      tileMode: TileMode.repeated,
                      stops: const [
                        0.6,
                        0.9
                      ],
                      colors: [
                        const Color(0xff87643E),
                        const Color(0xff87643E).withOpacity(.7)
                      ]),
                ),
                child: const FlexibleSpaceBar(
                    title: Text('Feed in Store'),
                    centerTitle: true,
                    background:
                        Image(image: AssetImage('assets/images/back.png'))),
              ),
            ),
            const SliverToBoxAdapter(
              child: Text('Stored Feed here'),
            )
          ],
        ),
      ),
    );
  }
}
