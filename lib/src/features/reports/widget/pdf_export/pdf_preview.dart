import 'dart:io';

import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/widget/pdf_export/pdf/pdf_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends ConsumerWidget {
  final Feed feed;
  final String type;
  const PdfPreviewPage( {super.key, required this.feed, required this.type,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final locale = Localizations.localeOf(context);
    final format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, );
    final currency = format.currencySymbol;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Ebena Feed Estimator | ${feed.feedName!.toUpperCase()} Print Preview'),
      ),
      body: PdfPreview(build: (context) => makePdf(feed, ref, type, currency)),
    );
  }
}
