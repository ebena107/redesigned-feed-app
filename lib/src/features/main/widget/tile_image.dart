import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:flutter/material.dart';

class FeedTileImage extends StatelessWidget {
  final int? id;

  const FeedTileImage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Commons.appCarrotColor,
      color: const Color(0xff87643E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Image.asset(
        feedImage(id: id),
        fit: BoxFit.cover,
      ),
    );
  }
}
