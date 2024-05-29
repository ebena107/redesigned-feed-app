import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FooterResultCard extends ConsumerWidget {
  final num? feedId;
  const FooterResultCard({
    super.key,
    required this.feedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Result> data = ref.watch(resultProvider).results;
    final myResult = data.firstWhere((element) => element.feedId == feedId,
        orElse: () => Result());
    return myResult.mEnergy != null
        ? Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ContentCard(
                      title: 'Energy',
                      value: myResult.mEnergy!.round(),
                    ),
                    ContentCard(
                      title: 'Fat',
                      value: myResult.cFat,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    ContentCard(
                      title: 'Protein',
                      value: myResult.cProtein!.ceilToDouble(),
                    ),
                    ContentCard(
                      title: 'Fiber',
                      value: myResult.cFibre,
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

class ContentCard extends StatelessWidget {
  final String? title;
  final num? value;
  const ContentCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      //   color: Commons.appBackgroundColor.withOpacity(.8),
      child: Center(
        child: Column(
          children: [
            Text(
              title!,
              style: const TextStyle(
                fontSize: 10,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              //value!.toStringAsFixed(2),
              value!.toString(),
              // value!.toInt().toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
