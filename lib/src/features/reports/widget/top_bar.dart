import 'package:feed_estimator/src/core/constants/common.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopBar extends StatelessWidget {
  final String title;

  const TopBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.arrow_right_arrow_left,
              color: AppConstants.appBackgroundColor),
        ),
      ],
      title: SizedBox(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: AppConstants.appBackgroundColor,
              fontSize: 24,
              fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
