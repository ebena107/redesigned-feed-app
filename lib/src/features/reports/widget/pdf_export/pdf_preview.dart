import 'dart:io';

import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/widget/pdf_export/pdf/pdf_export.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends ConsumerWidget {
  final Feed feed;
  final String type;
  final int? feedId;
  const PdfPreviewPage({
    super.key,
    this.feedId,
    required this.feed,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final locale = Localizations.localeOf(context);
    debugPrint(
        'feedId: $feedId, type: - $type , feed - ${feed.toJson().toString()}');
    final format = NumberFormat.simpleCurrency(
      locale: Platform.localeName,
    );
    final currency = format.currencySymbol;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.pdfPreviewTitle(feed.feedName!.toUpperCase())),
      ),
      body: PdfPreview(build: (context) => makePdf(ref, type, feed, currency)),
    );
  }
}
