import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnifiedGradientHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Color> gradientColors;
  final List<Widget>? actions;
  final Widget? leading;
  final double? expandedHeight;
  final bool centerTitle;
  final String? backgroundImage;
  final Widget? bottom;

  const UnifiedGradientHeader({
    super.key,
    required this.title,
    required this.gradientColors,
    this.subtitle,
    this.actions,
    this.leading,
    this.expandedHeight,
    this.centerTitle = true,
    this.backgroundImage = 'assets/images/back.png',
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultHeight = MediaQuery.of(context).size.height * 0.25;

    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: true,
      expandedHeight: expandedHeight ?? defaultHeight,
      leading: leading,
      actions: actions,
      backgroundColor: gradientColors.first,
      foregroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: gradientColors.first,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: FlexibleSpaceBar(
          centerTitle: centerTitle,
          titlePadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                    ],
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
          ),
          background: Stack(
            fit: StackFit.expand,
            children: [
              if (backgroundImage != null)
                Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    backgroundImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              if (bottom != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: bottom!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
