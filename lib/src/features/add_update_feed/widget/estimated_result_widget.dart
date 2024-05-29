import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:flutter/material.dart';

class ResultEstimateCard extends StatelessWidget {
  final Result data;
  final int? feedId;
  const ResultEstimateCard({required this.data, super.key, this.feedId});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: feedId != null ? const Color(0xffff6d00) : const Color(0xff2962ff),
      elevation: 1,
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                EstimatedContentCard(
                  value: data.mEnergy,
                  title: 'Energy: ',
                  //   unit: ' kcal',
                ),
                EstimatedContentCard(
                  value: data.cProtein,
                  title: 'cProtein: ',
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                EstimatedContentCard(
                  value: data.cFibre,
                  title: 'crude Fibre: ',
                ),
                EstimatedContentCard(
                  value: data.cFat,
                  title: 'crude Fat: ',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EstimatedContentCard extends StatelessWidget {
  final String? title;
  final num? value;
  final String? unit;
  const EstimatedContentCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppConstants.appBackgroundColor,
                  ),
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    value!.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: AppConstants.appBackgroundColor,
                    ),
                  ),
                  Text(
                    unit ?? "",
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppConstants.appBackgroundColor,
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
