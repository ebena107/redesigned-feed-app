import 'dart:typed_data';

import 'package:feed_estimator/src/core/constants/common.dart';

import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:feed_estimator/src/features/main/model/feed.dart';

import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart';

Future<Uint8List> makePdf(WidgetRef ref, String type, Feed feed, String currency) async {
  final pdf = Document(
      title: "Feed Estimator",
      author: "ebena.com.ng",
      subject: "Feed Analysis",
      creator: "Ebena Agro Ltd");
 // final feed = ref.watch(feedProvider).newFeed;
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List());

  final myFeedLogo = MemoryImage(
      (await rootBundle.load(feedImage(id: feed.animalId as int)))
          .buffer
          .asUint8List());
  var data = await rootBundle.load('assets/fonts/RobotoRegular.ttf');
  final font = Font.ttf(data);

  String? name(num? id) {
    final ingredients = ref.watch(ingredientProvider).ingredients;
    return ingredients.firstWhere((e) => e.ingredientId == id).name;
  }

  num calculateTotalQuantity() {
    final total = feed.feedIngredients!
        .fold(0, (num sum, ingredient) => sum + (ingredient.quantity as num));
    return total;
  }

  num calculatePercent(num? ingQty) {
    final total = calculateTotalQuantity();

    if (ingQty == 0) {
      return 0;
    } else {
      return 100 * (ingQty! / total);
    }
  }

  // final locale = ref.watch(deviceLocaleProvider).value;
  //final format = NumberFormat.simpleCurrency(locale: locale.toString());
  //final currency = format.currencySymbol;

  pdf.addPage(
    Page(
      clip: true,
      build: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  SizedBox(height: 80, width: 80, child: Image(myFeedLogo)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("feed Name: ${feed.feedName!.toUpperCase()}",
                            style: Theme.of(context)
                                .header3
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(
                            "animal Type : ${animalName(id: feed.animalId as int)}",
                            style: Theme.of(context).header4),
                        SizedBox(height: 10),
                        Text(
                            "Last Modified : ${secondToDate(feed.timestampModified as int)}",
                            style: Theme.of(context).header4),
                        SizedBox(height: 10),
                      ]),
                ]),
                SizedBox(height: 90, width: 90, child: Image(imageLogo))
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(type == "estimate" ? 'ESTIMATED REPORT' : 'REPORT',
                  style: Theme.of(context)
                      .header3
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    width: double.infinity,
                    height: 30,
                    color: PdfColors.grey800,
                    child: Center(
                      child: Text('FEED INGREDIENTS',
                          style: Theme.of(context).header2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: PdfColors.white),
                          textAlign: TextAlign.center),
                    ))),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                ...feed.feedIngredients!.map(
                  (e) => TableRow(
                    children: [
                      SizedBox(
                        width: 40,
                        child: paddedText(
                            (feed.feedIngredients!.indexOf(e) + 1).toString(),
                            align: TextAlign.right),
                      ),
                      Expanded(
                          // width: 40,
                          child: paddedText(
                        name(e.ingredientId) as String,
                      )),
                      SizedBox(
                          width: 100,
                          child: paddedText(e.quantity!.toStringAsFixed(2),
                              align: TextAlign.center)),
                      SizedBox(
                          width: 100,
                          child: paddedText(
                              ' ${calculatePercent(e.quantity).toStringAsFixed(2)}%',
                              align: TextAlign.center)),
                    ],
                  ),
                ),
                TableRow(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      // borderRadius: BorderRadius.circular(10),
                      color: PdfColors.grey300,
                    ),
                    children: [
                      SizedBox(),
                      paddedText('TOTAL', align: TextAlign.right),
                      paddedText(calculateTotalQuantity().toStringAsFixed(2),
                          align: TextAlign.center),
                      paddedText("100%", align: TextAlign.center)
                    ])
              ],
            ),
            // SizedBox(height: 20),
          ],
        );
      },
    ),
  );

  pdf.addPage(
    Page(
      build: (context) {
        num calculateTotalQuantity() {
          final total = feed.feedIngredients!.fold(
              0, (num sum, ingredient) => sum + (ingredient.quantity as num));
          return total;
        }

        final provider = ref.watch(resultProvider);
        final data = provider.results;

        //final result = feed.feedId == 9999 || feed.feedId == null
        final result = type == 'estimate'
            ? provider.myResult
            : provider.results.isNotEmpty
                ? data.firstWhere((r) => r.feedId == feed.feedId,
                    orElse: () => Result())
                : null;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(height: 80, width: 80, child: Image(myFeedLogo)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("feed Name: ${feed.feedName!.toUpperCase()}",
                            style: Theme.of(context)
                                .header3
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(
                            "animal Type : ${animalName(id: feed.animalId as int)}",
                            style: Theme.of(context).header4),
                        SizedBox(height: 10),
                        Text(
                            "Last Modified : ${secondToDate(feed.timestampModified as int)}",
                            style: Theme.of(context).header4),
                        SizedBox(height: 10),
                        Text(
                            "Total Quantity : ${calculateTotalQuantity().toStringAsFixed(2)} Kg",
                            style: Theme.of(context)
                                .header4
                                .copyWith(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 100, width: 100, child: Image(imageLogo))
              ],
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                height: 40,
                color: PdfColors.grey800,
                child: Center(
                  child: Text(
                      type == 'estimate'
                          ? 'ESTIMATED FEED ANALYSIS'
                          : 'FEED ANALYSIS',
                      style: Theme.of(context).header2.copyWith(
                          fontWeight: FontWeight.bold, color: PdfColors.white),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText(1.toString(), align: TextAlign.right),
                    ),
                    Expanded(
                        // width: 40,
                        child: paddedText(feed.animalId == 5
                            ? 'Digestive Energy'
                            : 'Metabolic Energy')),
                    SizedBox(
                        width: 120,
                        child: paddedText(
                            result!.mEnergy != null
                                ? result.mEnergy!.toStringAsFixed(2)
                                : "0",
                            align: TextAlign.center)),
                    SizedBox(
                        width: 80,
                        child: paddedText('Kcal/Kg', align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText(2.toString(), align: TextAlign.right),
                    ),
                    Expanded(
                        // width: 40,
                        child: paddedText('Crude Protein')),
                    SizedBox(
                        width: 120,
                        child: paddedText(
                            result.cProtein != null
                                ? result.cProtein!.toStringAsFixed(2)
                                : "0",
                            align: TextAlign.center)),
                    SizedBox(
                        width: 80,
                        child: paddedText('%/Kg', align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText(3.toString(), align: TextAlign.right),
                    ),
                    Expanded(
                        // width: 40,
                        child: paddedText('Crude Fiber')),
                    SizedBox(
                        width: 120,
                        child: paddedText(result.cFibre!.toStringAsFixed(2),
                            align: TextAlign.center)),
                    SizedBox(
                        width: 80,
                        child: paddedText('%/Kg', align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText(4.toString(), align: TextAlign.right),
                    ),
                    Expanded(
                        // width: 40,
                        child: paddedText('Crude Fat')),
                    SizedBox(
                        width: 120,
                        child: paddedText(result.cFat!.toStringAsFixed(2),
                            align: TextAlign.center)),
                    SizedBox(
                        width: 80,
                        child: paddedText('%/Kg', align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText(5.toString(), align: TextAlign.right),
                    ),
                    Expanded(
                        // width: 40,
                        child: paddedText('Calcium')),
                    SizedBox(
                        width: 120,
                        child: paddedText(result.calcium!.toStringAsFixed(2),
                            align: TextAlign.center)),
                    SizedBox(
                        width: 80,
                        child: paddedText('g/Kg', align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText(6.toString(), align: TextAlign.right),
                    ),
                    Expanded(
                        // width: 40,
                        child: paddedText('Phosphorus')),
                    SizedBox(
                        width: 120,
                        child: paddedText(result.phosphorus!.toStringAsFixed(2),
                            align: TextAlign.center)),
                    SizedBox(
                        width: 80,
                        child: paddedText('g/Kg', align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText(7.toString(), align: TextAlign.right),
                    ),
                    Expanded(
                        // width: 40,
                        child: paddedText('Lyzine')),
                    SizedBox(
                        width: 120,
                        child: paddedText(result.lysine!.toStringAsFixed(2),
                            align: TextAlign.center)),
                    SizedBox(
                        width: 80,
                        child: paddedText('g/Kg', align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText(8.toString(), align: TextAlign.right),
                    ),
                    Expanded(
                        // width: 40,
                        child: paddedText('Methionine')),
                    SizedBox(
                      width: 120,
                      child: paddedText(result.methionine!.toStringAsFixed(2),
                          align: TextAlign.center),
                    ),
                    SizedBox(
                        width: 80,
                        child: paddedText('g/Kg', align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(),
                    paddedText('COST /unit KG', align: TextAlign.right),
                    paddedText(result.costPerUnit!.toStringAsFixed(2),
                        align: TextAlign.center),
                    SizedBox(
                        width: 80,
                        child: paddedText('$currency/Kg',
                            align: TextAlign.center)),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(),
                    paddedText('TOTAL Cost', align: TextAlign.right),
                    paddedText(result.totalCost!.toStringAsFixed(2),
                        align: TextAlign.center),
                    SizedBox(
                        width: 80,
                        //child: paddedText(currency, align: TextAlign.center)),
                        child: Text(currency,
                            textAlign: TextAlign.center,
                            style: TextStyle(font: font))),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            paddedText(
                'Thank you for using Ebena Feed Estimator by Ebena Agro Ltd | http://ebena.com.ng, (c) ${DateTime.now().year}',
                align: TextAlign.center),
            Divider(height: 1),
            Row(
              children: [
                SizedBox(
                  child: paddedText('disclaimer:', align: TextAlign.right),
                ),
                Expanded(
                  child: Text(
                      'Ebena Agro Ltd (or designers of this app), or any of its subsidiaries, or any person associated with it, shall not be held liable by any person, or organization,or nation for any direct or indirect damages arising from any use of Feedcalc and/or the data generated by FeedCalc. It is explicitly stated that any financial or commercial loss (for instance: loss of data, loss of customers or of orders, loss of benefit, operating loss, opportunity loss, commercial trouble) or any action directed against FeedCalc by a third party constitutes an indirect damage and is not eligible for compensation of damage by Ebena Agro Ltd.',
                      style: Theme.of(context)
                          .defaultTextStyle
                          .copyWith(fontSize: 10, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.justify),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

Widget paddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: align,
      ),
    );
