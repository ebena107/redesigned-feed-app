import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:feed_estimator/src/features/price_management/provider/current_price_provider.dart';
import 'package:feed_estimator/src/features/price_management/provider/price_history_provider.dart';
import 'package:feed_estimator/src/features/price_management/view/price_history_view.dart';
import 'package:feed_estimator/src/features/price_management/widget/price_edit_dialog.dart';
import 'package:feed_estimator/src/features/price_management/widget/price_trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sampleHistory = <PriceHistory>[
    PriceHistory(
      id: 1,
      ingredientId: 1,
      price: 120.5,
      currency: 'NGN',
      effectiveDate: DateTime(2024, 1, 3),
      source: 'user',
      createdAt: 1700000000,
    ),
    PriceHistory(
      id: 2,
      ingredientId: 1,
      price: 100.0,
      currency: 'NGN',
      effectiveDate: DateTime(2024, 1, 1),
      source: 'user',
      createdAt: 1699900000,
    ),
  ];

  testWidgets('PriceHistoryView shows current price and history list',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          priceHistoryProvider(1).overrideWith(
            (ref) async => sampleHistory,
          ),
          currentPriceProvider(ingredientId: 1).overrideWith(
            (ref) async => 120.5,
          ),
        ],
        child: const MaterialApp(
          home: PriceHistoryView(
            ingredientId: 1,
            ingredientName: 'Maize',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Price History'), findsOneWidget);
    expect(find.textContaining('120.50 NGN'), findsWidgets);
    expect(find.textContaining('100.00 NGN'), findsWidgets);
  });

  testWidgets('PriceHistoryView Add Price opens PriceEditDialog',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          priceHistoryProvider(1).overrideWith(
            (ref) async => sampleHistory,
          ),
          currentPriceProvider(ingredientId: 1).overrideWith(
            (ref) async => 120.5,
          ),
        ],
        child: const MaterialApp(
          home: PriceHistoryView(
            ingredientId: 1,
            ingredientName: 'Maize',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Price'));
    await tester.pumpAndSettle();

    expect(find.byType(PriceEditDialog), findsOneWidget);
    expect(find.text('Record Price'), findsOneWidget);
  });

  testWidgets('PriceEditDialog renders price form', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PriceEditDialog(ingredientId: 1),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Record Price'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Currency'), findsOneWidget);
  });

  testWidgets('PriceTrendChart renders stats and latest label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PriceTrendChart(
            priceHistory: sampleHistory,
            currency: 'NGN',
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.textContaining('Min:'), findsOneWidget);
    expect(find.textContaining('Max:'), findsOneWidget);
    expect(find.textContaining('Latest:'), findsOneWidget);
  });
}
