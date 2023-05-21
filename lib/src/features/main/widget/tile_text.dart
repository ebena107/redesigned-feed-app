import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:flutter/material.dart';

class FeedTileText extends StatelessWidget {
  final String? name;

  const FeedTileText({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        name!,
        style: gridTitleTextStyle(),
      ),
    );
  }
}
