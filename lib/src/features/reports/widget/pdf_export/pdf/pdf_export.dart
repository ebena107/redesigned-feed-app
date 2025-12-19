import 'dart:convert';
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

Future<Uint8List> makePdf(
    WidgetRef ref, String type, Feed feed, String currency) async {
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
    try {
      return ingredients.firstWhere((e) => e.ingredientId == id).name;
    } catch (e) {
      return 'Unknown Ingredient';
    }
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

  // Consolidated into single MultiPage below
  pdf.addPage(
    MultiPage(
      build: (context) {
        num calculateTotalQuantity() {
          final total = feed.feedIngredients!.fold(
              0, (num sum, ingredient) => sum + (ingredient.quantity as num));
          return total;
        }

        final provider = ref.watch(resultProvider);
        final data = provider.results;

        final result = type == 'estimate'
            ? provider.myResult
            : provider.results.isNotEmpty
                ? data.firstWhere((r) => r.feedId == feed.feedId,
                    orElse: () => Result())
                : null;

        return [
          // Header with logos and feed info
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
          SizedBox(height: 16),
          // FEED INGREDIENTS Section
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [PdfColors.deepPurple700, PdfColors.deepPurple900],
                ),
              ),
              child: Center(
                child: Text('FEED INGREDIENTS',
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
                decoration: const BoxDecoration(color: PdfColors.grey300),
                children: [
                  SizedBox(
                    width: 40,
                    child: paddedText('S/N', align: TextAlign.center),
                  ),
                  Expanded(
                    child: paddedText('Ingredient Name', align: TextAlign.left),
                  ),
                  SizedBox(
                    width: 80,
                    child: paddedText('Quantity (Kg)', align: TextAlign.center),
                  ),
                  SizedBox(
                    width: 80,
                    child:
                        paddedText('Percentage (%)', align: TextAlign.center),
                  ),
                ],
              ),
              for (var i = 0; i < feed.feedIngredients!.length; i++)
                TableRow(
                  children: [
                    SizedBox(
                      width: 40,
                      child: paddedText((i + 1).toString(),
                          align: TextAlign.right),
                    ),
                    Expanded(
                      child: paddedText(
                          name(feed.feedIngredients![i].ingredientId) ?? '',
                          align: TextAlign.left),
                    ),
                    SizedBox(
                      width: 80,
                      child: paddedText(
                          feed.feedIngredients![i].quantity.toString(),
                          align: TextAlign.center),
                    ),
                    SizedBox(
                      width: 80,
                      child: paddedText(
                          ((feed.feedIngredients![i].quantity! /
                                      calculateTotalQuantity()) *
                                  100)
                              .toStringAsFixed(2),
                          align: TextAlign.center),
                    ),
                  ],
                ),
              TableRow(
                decoration: const BoxDecoration(color: PdfColors.grey300),
                children: [
                  SizedBox(
                    width: 40,
                    child: Container(),
                  ),
                  Expanded(
                    child: paddedText('TOTAL', align: TextAlign.right),
                  ),
                  SizedBox(
                    width: 80,
                    child: paddedText(calculateTotalQuantity().toString(),
                        align: TextAlign.center),
                  ),
                  SizedBox(
                    width: 80,
                    child: paddedText('100%', align: TextAlign.center),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [PdfColors.deepPurple700, PdfColors.deepPurple900],
                ),
              ),
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
                          ? 'Digestive Energy (DE)'
                          : feed.animalId == 1
                              ? 'Net Energy (NE)'
                              : 'Metabolizable Energy (ME)')),
                  SizedBox(
                      width: 120,
                      child: paddedText(
                          result != null && result.mEnergy != null
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
                          result != null && result.cProtein != null
                              ? result.cProtein!.toStringAsFixed(2)
                              : "0",
                          align: TextAlign.center)),
                  SizedBox(
                      width: 80,
                      child: paddedText('%', align: TextAlign.center)),
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
                      child: paddedText(
                          result != null && result.cFibre != null
                              ? result.cFibre!.toStringAsFixed(2)
                              : "0",
                          align: TextAlign.center)),
                  SizedBox(
                      width: 80,
                      child: paddedText('%', align: TextAlign.center)),
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
                      child: paddedText(
                          result != null && result.cFat != null
                              ? result.cFat!.toStringAsFixed(2)
                              : "0",
                          align: TextAlign.center)),
                  SizedBox(
                      width: 80,
                      child: paddedText('%', align: TextAlign.center)),
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
                      child: paddedText(
                          result != null && result.calcium != null
                              ? result.calcium!.toStringAsFixed(2)
                              : "0",
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
                      child: paddedText(
                          result != null && result.phosphorus != null
                              ? result.phosphorus!.toStringAsFixed(2)
                              : "0",
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
                      child: paddedText(
                          result != null && result.lysine != null
                              ? result.lysine!.toStringAsFixed(2)
                              : "0",
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
                    child: paddedText(
                        result != null && result.methionine != null
                            ? result.methionine!.toStringAsFixed(2)
                            : "0",
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
                  paddedText(
                      result != null && result.costPerUnit != null
                          ? result.costPerUnit!.toStringAsFixed(2)
                          : "0",
                      align: TextAlign.center),
                  SizedBox(
                      width: 80,
                      child:
                          paddedText('$currency/Kg', align: TextAlign.center)),
                ],
              ),
              TableRow(
                children: [
                  SizedBox(),
                  paddedText('TOTAL Cost', align: TextAlign.right),
                  paddedText(
                      result != null && result.totalCost != null
                          ? result.totalCost!.toStringAsFixed(2)
                          : "0",
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
          SizedBox(height: 24),
          // Enhanced v5 metrics
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [PdfColors.teal700, PdfColors.teal900],
                ),
              ),
              child: Text('PROXIMATE ANALYSIS & PHOSPHORUS',
                  style: Theme.of(context).header4.copyWith(
                      fontWeight: FontWeight.bold, color: PdfColors.white),
                  textAlign: TextAlign.center),
            ),
          ),
          Table(
            border: TableBorder.all(color: PdfColors.black),
            columnWidths: {
              0: const FlexColumnWidth(2),
              1: const FlexColumnWidth(1.5),
              2: const FlexColumnWidth(1),
            },
            children: [
              TableRow(children: [
                paddedText('Nutrient'),
                paddedText('Value', align: TextAlign.center),
                paddedText('Unit', align: TextAlign.center),
              ]),
              TableRow(children: [
                paddedText('Ash'),
                paddedText(result?.ash?.toStringAsFixed(1) ?? '--',
                    align: TextAlign.center),
                paddedText('%', align: TextAlign.center),
              ]),
              TableRow(children: [
                paddedText('Moisture'),
                paddedText(result?.moisture?.toStringAsFixed(1) ?? '--',
                    align: TextAlign.center),
                paddedText('%', align: TextAlign.center),
              ]),
              TableRow(children: [
                paddedText('Total Phosphorus'),
                paddedText(result?.totalPhosphorus?.toStringAsFixed(2) ?? '--',
                    align: TextAlign.center),
                paddedText('g/Kg', align: TextAlign.center),
              ]),
              TableRow(children: [
                paddedText('Available Phosphorus'),
                paddedText(
                    result?.availablePhosphorus?.toStringAsFixed(2) ?? '--',
                    align: TextAlign.center),
                paddedText('g/Kg', align: TextAlign.center),
              ]),
              TableRow(children: [
                paddedText('Phytate Phosphorus'),
                paddedText(
                    result?.phytatePhosphorus?.toStringAsFixed(2) ?? '--',
                    align: TextAlign.center),
                paddedText('g/Kg', align: TextAlign.center),
              ]),
            ],
          ),
          SizedBox(height: 24),
          // Amino Acids Section
          if (result != null &&
              result.aminoAcidsTotalJson != null &&
              result.aminoAcidsTotalJson!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [PdfColors.teal700, PdfColors.teal900],
                  ),
                ),
                child: Text('AMINO ACID PROFILE',
                    style: Theme.of(context).header4.copyWith(
                        fontWeight: FontWeight.bold, color: PdfColors.white),
                    textAlign: TextAlign.center),
              ),
            ),
            () {
              try {
                final aminoTotal = jsonDecode(result.aminoAcidsTotalJson!);
                final aminoSid = result.aminoAcidsSidJson != null &&
                        result.aminoAcidsSidJson!.isNotEmpty
                    ? jsonDecode(result.aminoAcidsSidJson!)
                    : <String, dynamic>{};

                return Table(
                  border: TableBorder.all(color: PdfColors.black),
                  columnWidths: {
                    0: const FlexColumnWidth(2),
                    1: const FlexColumnWidth(1.5),
                    2: const FlexColumnWidth(1.5),
                    3: const FlexColumnWidth(1),
                  },
                  children: [
                    // Header row
                    TableRow(
                      decoration: BoxDecoration(color: PdfColors.grey200),
                      children: [
                        paddedText('Amino Acid', align: TextAlign.left),
                        paddedText('Total (g/Kg)', align: TextAlign.center),
                        paddedText('SID (g/Kg)', align: TextAlign.center),
                        paddedText('Unit', align: TextAlign.center),
                      ],
                    ),
                    // Data rows
                    ...aminoTotal.entries.map((entry) {
                      final name = entry.key.toString();
                      final totalValue = entry.value is num
                          ? (entry.value as num).toStringAsFixed(1)
                          : '--';
                      final sidValue = aminoSid[name] is num
                          ? (aminoSid[name] as num).toStringAsFixed(1)
                          : '--';

                      return TableRow(children: [
                        paddedText(name[0].toUpperCase() + name.substring(1)),
                        paddedText(totalValue, align: TextAlign.center),
                        paddedText(sidValue, align: TextAlign.center),
                        paddedText('g/Kg', align: TextAlign.center),
                      ]);
                    }).toList(),
                  ],
                );
              } catch (e) {
                return SizedBox();
              }
            }(),
            SizedBox(height: 24),
          ],
          // Warnings Section - Always show if available
          if (result != null &&
              result.warningsJson != null &&
              result.warningsJson!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [PdfColors.orange700, PdfColors.deepOrange900],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('⚠ ',
                        style: Theme.of(context)
                            .header3
                            .copyWith(color: PdfColors.white)),
                    Text('WARNINGS & RECOMMENDATIONS',
                        style: Theme.of(context).header4.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PdfColors.white)),
                  ],
                ),
              ),
            ),
            () {
              try {
                final warnings = jsonDecode(result.warningsJson!);
                if (warnings is List && warnings.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: PdfColors.orange),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: warnings
                          .map((w) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('• ',
                                        style: Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(fontSize: 11)),
                                    Expanded(
                                      child: Text(w.toString(),
                                          style: Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(fontSize: 10)),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  );
                }
                return SizedBox();
              } catch (e) {
                return SizedBox();
              }
            }(),
            SizedBox(height: 16),
          ],
          // Footer
          paddedText(
              'Thank you for using Ebena Feed Estimator by Ebena Agro Ltd',
              align: TextAlign.center),
          paddedText(
              'copyright:  http://ebena.com.ng, (c) ${DateTime.now().year}',
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
        ];
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
