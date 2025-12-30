import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' as semantics;
import 'package:intl/intl.dart';

/// Simple price trend chart visualization
/// Shows price changes over time with a line graph
class PriceTrendChart extends StatelessWidget {
  final List<PriceHistory> priceHistory;
  final String currency;

  const PriceTrendChart({
    required this.priceHistory,
    this.currency = 'NGN',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (priceHistory.isEmpty) {
      return Semantics(
        label: 'Price trend chart is empty. No price data is available.',
        child: Container(
          height: 200,
          decoration: UIConstants.cardDecoration(),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No price data available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ),
      );
    }

    // Sort by date ascending for display
    final sortedHistory = [...priceHistory]
      ..sort((a, b) => a.effectiveDate.compareTo(b.effectiveDate));

    // Calculate min/max for scaling
    final prices = sortedHistory.map((p) => p.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;

    // Constants for chart dimensions
    const chartHeight = 200.0;
    const chartWidth = double.infinity;
    const padding = 16.0;

    return Container(
      decoration: UIConstants.cardDecoration(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and stats (wrap to avoid overflow on small screens)
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: UIConstants.paddingSmall,
            runSpacing: UIConstants.paddingSmall,
            children: [
              Text(
                'Price Trend',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Min: ${minPrice.toStringAsFixed(2)} $currency',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.green,
                        ),
                  ),
                  Text(
                    'Max: ${maxPrice.toStringAsFixed(2)} $currency',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: UIConstants.paddingNormal),

          // Chart with accessibility
          Semantics(
            label:
                'Price trend chart showing ${sortedHistory.length} data points from ${DateFormat('MMM dd').format(sortedHistory.first.effectiveDate)} to ${DateFormat('MMM dd').format(sortedHistory.last.effectiveDate)}. Price ranges from ${minPrice.toStringAsFixed(2)} to ${maxPrice.toStringAsFixed(2)} $currency.',
            child: SizedBox(
              height: chartHeight,
              width: chartWidth,
              child: CustomPaint(
                painter: _PriceTrendPainter(
                  priceHistory: sortedHistory,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  priceRange: priceRange,
                  padding: padding,
                ),
              ),
            ),
          ),

          const SizedBox(height: UIConstants.paddingNormal),

          // Legend with latest price
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: UIConstants.paddingSmall,
              runSpacing: UIConstants.paddingSmall,
              children: [
                Text(
                  'Latest: ${sortedHistory.last.price.toStringAsFixed(2)} $currency',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'as of ${DateFormat('MMM dd, yyyy').format(sortedHistory.last.effectiveDate)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for price trend chart
class _PriceTrendPainter extends CustomPainter {
  final List<PriceHistory> priceHistory;
  final double minPrice;
  final double maxPrice;
  final double priceRange;
  final double padding;

  _PriceTrendPainter({
    required this.priceHistory,
    required this.minPrice,
    required this.maxPrice,
    required this.priceRange,
    required this.padding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (priceHistory.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final axisPaint = Paint()
      ..color = Colors.grey[300] ?? Colors.grey
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = Colors.grey[200] ?? Colors.grey
      ..strokeWidth = 0.5;

    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2);

    // Draw grid lines
    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = padding + (chartHeight / gridLines * i);
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );
    }

    // Draw axes
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      axisPaint,
    );

    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, size.height - padding),
      axisPaint,
    );

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < priceHistory.length; i++) {
      final price = priceHistory[i].price;

      // X position: spread evenly across chart width
      final x = padding +
          (chartWidth /
              (priceHistory.length - 1 > 0 ? priceHistory.length - 1 : 1) *
              i);

      // Y position: scale from price range (inverted because y increases downward)
      final normalizedPrice =
          (price - minPrice) / (priceRange > 0 ? priceRange : 1);
      final y = (size.height - padding) - (normalizedPrice * chartHeight);

      points.add(Offset(x, y));
    }

    // Draw line connecting points
    if (points.length > 1) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Highlight latest point
    final latestPointPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawCircle(points.last, 6, latestPointPaint);

    // Draw labels for first and last dates
    if (priceHistory.length > 1) {
      final dateFormat = DateFormat('MM/dd');

      // First date label
      final firstDateText = dateFormat.format(priceHistory.first.effectiveDate);
      _drawText(
        canvas,
        firstDateText,
        Offset(padding, size.height - padding + 20),
        12,
        Colors.grey[600] ?? Colors.grey,
      );

      // Last date label
      final lastDateText = dateFormat.format(priceHistory.last.effectiveDate);
      _drawText(
        canvas,
        lastDateText,
        Offset(size.width - padding - 30, size.height - padding + 20),
        12,
        Colors.grey[600] ?? Colors.grey,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    double fontSize,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      ),
      textDirection: semantics.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_PriceTrendPainter oldDelegate) {
    return oldDelegate.priceHistory != priceHistory ||
        oldDelegate.minPrice != minPrice ||
        oldDelegate.maxPrice != maxPrice;
  }
}
