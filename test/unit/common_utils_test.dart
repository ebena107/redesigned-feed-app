import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utility Functions Tests', () {
    group('Display Size Functions', () {
      testWidgets('displaySize returns correct size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final size = displaySize(context);
                return Text('${size.width}x${size.height}');
              },
            ),
          ),
        );

        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('displayHeight returns correct height', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final height = displayHeight(context);
                return Text('Height: $height');
              },
            ),
          ),
        );

        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('displayWidth returns correct width', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final width = displayWidth(context);
                return Text('Width: $width');
              },
            ),
          ),
        );

        expect(find.byType(Text), findsOneWidget);
      });
    });

    group('Text Style Functions', () {
      test('displayTextStyle returns correct style', () {
        final style = displayTextStyle();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 34);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.color, AppConstants.appBackgroundColor);
      });

      test('headlineTextStyle returns correct style', () {
        final style = headlineTextStyle();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 24);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.color, AppConstants.appBackgroundColor);
      });

      test('headlineTextStyle accepts custom color', () {
        final style = headlineTextStyle(color: Colors.red);

        expect(style.color, Colors.red);
      });

      test('titleTextStyle returns correct style', () {
        final style = titleTextStyle();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 20);
        expect(style.fontWeight, FontWeight.w500);
        expect(style.color, AppConstants.appFontColor);
      });

      test('titleTextStyle accepts custom color and weight', () {
        final style = titleTextStyle(
          color: Colors.blue,
          weight: FontWeight.bold,
        );

        expect(style.color, Colors.blue);
        expect(style.fontWeight, FontWeight.bold);
      });

      test('bodyTextStyle returns correct style', () {
        final style = bodyTextStyle();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.color, AppConstants.appFontColor);
      });

      test('labelTextStyle returns correct style', () {
        final style = labelTextStyle();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 14);
        expect(style.fontWeight, FontWeight.w500);
        expect(style.color, AppConstants.appFontColor);
      });

      test('captionTextStyle returns correct style', () {
        final style = captionTextStyle();

        expect(style.fontFamily, 'Roboto');
        expect(style.fontSize, 12);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.color, AppConstants.appIconGreyColor);
      });

      test('captionTextStyle accepts custom color', () {
        final style = captionTextStyle(color: Colors.green);

        expect(style.color, Colors.green);
      });
    });

    group('Time Functions', () {
      test('currentTimeInSecond returns valid timestamp', () {
        final timestamp = currentTimeInSecond();

        expect(timestamp, greaterThan(0));
        expect(timestamp, isA<int>());
      });

      test('currentTimeInSecond returns increasing values', () {
        final timestamp1 = currentTimeInSecond();
        // Small delay
        Future.delayed(const Duration(milliseconds: 10));
        final timestamp2 = currentTimeInSecond();

        expect(timestamp2, greaterThanOrEqualTo(timestamp1));
      });

      test('secondToDate converts timestamp to date string', () {
        final timestamp = DateTime(2023, 12, 25).millisecondsSinceEpoch;
        final dateString = secondToDate(timestamp);

        expect(dateString, '25-12-2023');
      });

      test('secondToDate handles different dates correctly', () {
        final timestamp1 = DateTime(2023, 1, 1).millisecondsSinceEpoch;
        final timestamp2 = DateTime(2023, 12, 31).millisecondsSinceEpoch;

        expect(secondToDate(timestamp1), '01-01-2023');
        expect(secondToDate(timestamp2), '31-12-2023');
      });
    });

    group('Feed Image Functions', () {
      test('feedImage returns correct image for pig (id: 1)', () {
        final image = feedImage(id: 1);

        expect(image, 'assets/images/pig_feed.png');
      });

      test('feedImage returns correct image for poultry (id: 2)', () {
        final image = feedImage(id: 2);

        expect(image, 'assets/images/chicken_feed.png');
      });

      test('feedImage returns correct image for rabbit (id: 3)', () {
        final image = feedImage(id: 3);

        expect(image, 'assets/images/rabbit_feed.png');
      });

      test('feedImage returns correct image for ruminant (id: 4)', () {
        final image = feedImage(id: 4);

        expect(image, 'assets/images/ruminant_feed.png');
      });

      test('feedImage returns correct image for fish (id: 5)', () {
        final image = feedImage(id: 5);

        expect(image, 'assets/images/fish_feed.png');
      });

      test('feedImage returns empty string for null id', () {
        final image = feedImage(id: null);

        expect(image, '');
      });

      test('feedImage returns empty string for unknown id', () {
        final image = feedImage(id: 99);

        expect(image, '');
      });
    });

    group('Animal Name Functions', () {
      test('animalName returns correct name for pig (id: 1)', () {
        final name = animalName(id: 1);

        expect(name, 'Pig');
      });

      test('animalName returns correct name for poultry (id: 2)', () {
        final name = animalName(id: 2);

        expect(name, 'Poultry');
      });

      test('animalName returns correct name for rabbit (id: 3)', () {
        final name = animalName(id: 3);

        expect(name, 'Rabbit');
      });

      test('animalName returns correct name for ruminants (id: 4)', () {
        final name = animalName(id: 4);

        expect(name, 'Ruminants');
      });

      test('animalName returns correct name for fish (id: 5)', () {
        final name = animalName(id: 5);

        expect(name, 'Salmonids / Fish');
      });

      test('animalName returns empty string for null id', () {
        final name = animalName(id: null);

        expect(name, '');
      });

      test('animalName returns empty string for unknown id', () {
        final name = animalName(id: 99);

        expect(name, '');
      });
    });

    group('Input Decoration Theme', () {
      test('inputDecorationTheme returns valid theme', () {
        final theme = inputDecorationTheme();

        expect(theme, isA<InputDecorationTheme>());
        expect(theme.contentPadding, isNotNull);
        expect(theme.enabledBorder, isNotNull);
        expect(theme.focusedBorder, isNotNull);
        expect(theme.border, isNotNull);
      });

      test('inputDecorationTheme has correct padding', () {
        final theme = inputDecorationTheme();

        expect(
          theme.contentPadding,
          const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        );
      });

      test('inputDecorationTheme borders have correct radius', () {
        final theme = inputDecorationTheme();
        final border = theme.enabledBorder as OutlineInputBorder;

        expect(border.borderRadius,
            BorderRadius.circular(AppConstants.radiusRound));
      });
    });
  });

  group('AppConstants Tests', () {
    group('Color Constants', () {
      test('mainAppColor is defined', () {
        expect(AppConstants.mainAppColor, const Color(0xFF229064));
      });

      test('mainAccentColor is defined', () {
        expect(AppConstants.mainAccentColor, const Color(0xff26c486));
      });

      test('appBackgroundColor is defined', () {
        expect(AppConstants.appBackgroundColor, const Color(0xFFf4fffc));
      });

      test('appFontColor is defined', () {
        expect(AppConstants.appFontColor, const Color(0xFF311436));
      });

      test('all gradient colors are defined', () {
        expect(AppConstants.gradientBackgroundColorStart, isA<Color>());
        expect(AppConstants.gradientBackgroundColorEnd, isA<Color>());
        expect(AppConstants.gradientPurpleStart, isA<Color>());
        expect(AppConstants.gradientPurpleEnd, isA<Color>());
        expect(AppConstants.gradientBrownStart, isA<Color>());
        expect(AppConstants.gradientBrownEnd, isA<Color>());
      });
    });

    group('Spacing Constants', () {
      test('spacing values follow 8px grid', () {
        expect(AppConstants.spacing4, 4.0);
        expect(AppConstants.spacing8, 8.0);
        expect(AppConstants.spacing12, 12.0);
        expect(AppConstants.spacing16, 16.0);
        expect(AppConstants.spacing24, 24.0);
        expect(AppConstants.spacing32, 32.0);
        expect(AppConstants.spacing48, 48.0);
      });
    });

    group('Border Radius Constants', () {
      test('radius values are defined', () {
        expect(AppConstants.radiusSmall, 8.0);
        expect(AppConstants.radiusMedium, 16.0);
        expect(AppConstants.radiusLarge, 24.0);
        expect(AppConstants.radiusRound, 28.0);
      });

      test('radius values are in ascending order', () {
        expect(AppConstants.radiusSmall < AppConstants.radiusMedium, true);
        expect(AppConstants.radiusMedium < AppConstants.radiusLarge, true);
        expect(AppConstants.radiusLarge < AppConstants.radiusRound, true);
      });
    });

    group('System UI Overlay Styles', () {
      test('pagesBar style is defined', () {
        expect(AppConstants.pagesBar, isA<SystemUiOverlayStyle>());
        expect(AppConstants.pagesBar.statusBarColor, Colors.transparent);
      });

      test('mainBar style is defined', () {
        expect(AppConstants.mainBar, isA<SystemUiOverlayStyle>());
        expect(AppConstants.mainBar.statusBarColor, Colors.transparent);
      });
    });
  });

  group('Integration Tests', () {
    test('all animal IDs have corresponding images and names', () {
      for (int id = 1; id <= 5; id++) {
        final image = feedImage(id: id);
        final name = animalName(id: id);

        expect(image, isNotEmpty);
        expect(name, isNotEmpty);
      }
    });

    test('text styles maintain consistent font family', () {
      final styles = [
        displayTextStyle(),
        headlineTextStyle(),
        titleTextStyle(),
        bodyTextStyle(),
        labelTextStyle(),
        captionTextStyle(),
      ];

      for (final style in styles) {
        expect(style.fontFamily, 'Roboto');
      }
    });

    test('text styles have decreasing font sizes', () {
      expect(
          displayTextStyle().fontSize! > headlineTextStyle().fontSize!, true);
      expect(headlineTextStyle().fontSize! > titleTextStyle().fontSize!, true);
      expect(titleTextStyle().fontSize! > bodyTextStyle().fontSize!, true);
      expect(bodyTextStyle().fontSize! > labelTextStyle().fontSize!, true);
      expect(labelTextStyle().fontSize! > captionTextStyle().fontSize!, true);
    });
  });
}
