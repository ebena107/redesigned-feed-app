import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/navigation_providers.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';

import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';

import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/features/reports/widget/ingredients_list.dart';

import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:feed_estimator/src/utils/widgets/custom_stack_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnalysisPage extends ConsumerWidget {
  final String? id;
  final String? type;
  const AnalysisPage({
    Key? key,
    this.id,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final feedId = id != null ? int.tryParse(id!) : null;

    final List<Feed> feedList =
        feedId != null ? ref.watch(asyncMainProvider).value as List<Feed> : [];

    // final feed = feedId == 9999
    //     ? ref.watch(feedProvider).newFeed
    //     : feedList.firstWhere((f) => f.feedId == feedId, orElse: () => Feed());

    final feed = type == 'estimate'
        ? ref.watch(feedProvider).newFeed
        : feedList.firstWhere((f) => f.feedId == feedId, orElse: () => Feed());


    final toggle = ref.watch(resultProvider).toggle;

    return Scaffold(
      drawer: const FeedAppDrawer(),
      body: MultiHitStack(
        children: [
          SizedBox(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  pinned: true,
                  snap: false,
                  floating: true,
                  elevation: 0,
                  title: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Analysis Page",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppConstants.appBackgroundColor,
                              fontSize: 24,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            context.pushNamed("pdfPreview", extra: feed, queryParameters: {'type': type}),
                        icon: const Icon(Icons.picture_as_pdf_outlined,
                            color: AppConstants.appBackgroundColor),
                      ),
                    ],
                  ),
                  automaticallyImplyLeading: true,
                  backgroundColor: const Color(0xffA68F91),
                  expandedHeight: displayHeight(context) * .6,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        tileMode: TileMode.repeated,
                        stops: [0.6, 0.9],
                        colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                      ),
                    ),
                    child: FlexibleSpaceBar(
                        background: Image.asset(
                      'assets/images/back.png',
                      scale: 2,
                    )),
                  ),
                ),


              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: displayHeight(context) * .32),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(displayWidth(context) * .35),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  //tileMode: TileMode.repeated,
                  stops: [0.6, 0.99],
                  colors: [Colors.deepPurple, AppConstants.appBackgroundColor],
                )),
            height: displayHeight(context) * .8,
          ),
          // Container(
          //     width: displayWidth(context) * .91,
          //     margin: EdgeInsets.only(
          //       top: displayHeight(context) * .4,
          //       left: displayWidth(context) * .09,
          //     ),
          //     child: NameCard(feed: feed)),

          FeedImage(id: feed!.animalId as int),
          NameCard(feed: feed),
          ReturnButton(feedId: feedId),
          toggle
              ? Container(
                  //   alignment: Alignment.bottomCenter,

                  margin: EdgeInsets.only(
                    top: displayHeight(context) * .55,

                    // left: displayWidth(context) * .3,
                  ),
                  child: SizedBox(
                    height: displayHeight(context) * .5,
                    child: feedId != null || feed.feedId != null
                        ? SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: displayHeight(context) * .5,
                                    child: ReportIngredientList(feed: feed)),
                              ],
                            ))
                        : const Center(child: CircularProgressIndicator()),
                  ),
                )
              : Container(
                  //   alignment: Alignment.bottomCenter,

                  margin: EdgeInsets.only(
                    top: displayHeight(context) * .55,

                    // left: displayWidth(context) * .3,
                  ),
                  child: SizedBox(
                    height: displayHeight(context) * .43,
                    child: Column(
                      children: [
                        const Spacer(),
                        feedId != null || feed.feedId != null
                            ? ResultCard(
                                id: feedId ?? feed.feedId,
                                type: type,
                              )
                            : const Center(child: CircularProgressIndicator()),
                        const Spacer(),
                      ],
                    ),
                  ),
                )


        ],
      ),
      bottomNavigationBar: const ReportBottomBar(),
    );
  }


}

class ReturnButton extends ConsumerWidget {
  final num? feedId;
  const ReturnButton({
    Key? key,
    this.feedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return feedId == 9999
        ? Container(
            alignment: Alignment.center,
            height: 40,
            margin: EdgeInsets.only(
              top: displayHeight(context) * .52,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppConstants.appHintColor,
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                border: Border.all(
                    color: AppConstants.appShadowColor,
                    style: BorderStyle.solid,
                    width: 0.20),
                // color: Commons.appCarrotColor,
              ),
              width: displayWidth(context) * .5,
              child: TextButton(
                //  style: raisedButtonStyle,
                onPressed: () {
                  context.goNamed('newFeed',
                      queryParameters: {'id': feedId.toString()});
                  //    const IngredientList(),
                },
                child: const Text(
                  "Return to Edit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppConstants.appBackgroundColor, fontSize: 20),
                ),
              ),
            ))
        : const SizedBox();
  }
}

class NameCard extends ConsumerWidget {
  final Feed? feed;
  const NameCard({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      // height: displayHeight(context) * .1,
      height: displayHeight(context) * .1,
      margin: EdgeInsets.only(
        top: displayHeight(context) * .41,
        // left: displayWidth(context) / 8,
        //right: displayHeight(context) / 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              feed!.feedName.toString(),
              style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  //  color: backColor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
              // height: 20,
              ),
          Text(
            '${animalName(id: feed!.animalId as int)} feed',
            // style: listFieldStyle(context, mainColor),
          ),
          Text(
            'Modified: ${secondToDate(feed!.timestampModified as int?)}',
            // style: listFieldStyle(context, mainColor),
          ),
        ],
      ),
    );
  }
}

class FeedImage extends ConsumerWidget {
  final int? id;
  const FeedImage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(
        top: displayHeight(context) * .27,
        left: displayWidth(context) / 2 - displayHeight(context) * .07,
      ),
      child: CircleAvatar(
        radius: displayHeight(context) * .07,
        // radius: displayWidth(context) * .05,
        backgroundColor: AppConstants.appBackgroundColor,
        child: Image.asset(
          feedImage(id: id),
          fit: BoxFit.cover,
          scale: 1.2,
          // color: AppConstants.appCarrotColor,
        ),
      ),
    );
  }
}

class ResultCard extends ConsumerWidget {
//final FeedModel? feed;
  final num? id;
  final String? type;
  const ResultCard({
    Key? key,
    this.id,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(resultProvider);
    final data = provider.results;

    final result = type == 'estimate'
        ? provider.myResult
        : provider.results.isNotEmpty
            ? data.firstWhere((r) => r.feedId == id, orElse: () => Result())
            : null;

    return result != null
        ? Card(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EnergyContentCard(
                        title: 'Metabolic Energy',
                        value: result.mEnergy,
                        unit: 'Kcal/unit',
                      ),
                      UpperContentCard(
                        title: 'Crude Protein',
                        value: result.cProtein,
                        unit: '',
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: AppConstants.appIconGreyColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LowerContentCard(
                        title: 'Crude Fiber',
                        value: result.cFibre,
                        unit: '',
                      ),
                      LowerContentCard(
                        title: 'Crude Fat',
                        value: result.cFat,
                        unit: '',
                      ),
                      LowerContentCard(
                        title: 'Calcium',
                        value: result.calcium,
                        unit: '',
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: AppConstants.appIconGreyColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LowerContentCard(
                        title: 'Phosphorus',
                        value: result.phosphorus,
                        unit: '',
                      ),
                      LowerContentCard(
                        title: 'Lyzine',
                        value: result.lysine,
                        unit: '',
                      ),
                      LowerContentCard(
                        title: 'Methionine',
                        value: result.methionine,
                        unit: '',
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: AppConstants.appIconGreyColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EnergyContentCard(
                        title: 'Total Quantity',
                        value: result.totalQuantity,
                        unit: 'unit',
                      ),
                      EnergyContentCard(
                        title: 'Total Cost',
                        value: result.totalCost,
                        unit: '#',
                      ),
                      UpperContentCard(
                        title: 'cost / unit',
                        value: result.costPerUnit,
                        unit: '/unit',
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

class UpperContentCard extends StatelessWidget {
  final String? title;
  final num? value;
  final String? unit;
  const UpperContentCard({
    Key? key,
    required this.title,
    required this.value,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title!,
            style: const TextStyle(
                fontSize: 14, color: AppConstants.appBackgroundColor
                //  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value!.toStringAsFixed(2),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.appBackgroundColor),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                unit!,
                style: const TextStyle(
                    fontSize: 12, color: AppConstants.appBackgroundColor
                    //  fontWeight: FontWeight.bold,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class EnergyContentCard extends StatelessWidget {
  final String? title;
  final num? value;
  final String? unit;
  const EnergyContentCard({
    Key? key,
    required this.title,
    required this.value,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title!,
            style: const TextStyle(
                fontSize: 14, color: AppConstants.appBackgroundColor
                //  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value!.toStringAsFixed(0),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.appBackgroundColor),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                unit!,
                style: const TextStyle(
                    fontSize: 12, color: AppConstants.appBackgroundColor
                    //  fontWeight: FontWeight.bold,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class LowerContentCard extends StatelessWidget {
  final String? title;
  final num? value;
  final String? unit;
  const LowerContentCard({
    Key? key,
    required this.title,
    required this.value,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value!.toStringAsFixed(2),
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.appBackgroundColor),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            title!,
            style: const TextStyle(
                fontSize: 12, color: AppConstants.appBackgroundColor
                //  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class ReportBottomBar extends ConsumerWidget {
  const ReportBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appNavigationProvider).navIndex;
    return BottomNavigationBar(
      onTap: (int index) {
        ref.read(appNavigationProvider.notifier).changeIndex(index);
        _onItemTapped(index, context, ref);
      },
      backgroundColor: AppConstants.appBackgroundColor,
      currentIndex: currentIndex,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.list_bullet_below_rectangle),
          label: 'Analysis',
          backgroundColor: AppConstants.appCarrotColor,
        ),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_number),
            label: 'Ingredients Details'),
        //  BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
      ],
    );
  }
}

Future<void> _onItemTapped(
    int index, BuildContext context, WidgetRef ref) async {
  switch (index) {
    case 0:
      ref.read(resultProvider.notifier).toggle(false);
      break;
    case 1:
      ref.read(resultProvider.notifier).toggle(true);
      break;
  }
}
