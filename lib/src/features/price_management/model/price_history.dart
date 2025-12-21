import 'dart:convert';

/// Price history entry for tracking ingredient price changes over time
///
/// Supports user-editable prices with change tracking:
/// - Stores historical price data for trend analysis
/// - Tracks source (user/system/market) and notes
/// - Enables price comparison and forecasting
class PriceHistory {
  final int? id;
  final int ingredientId;
  final double price;
  final String currency;
  final DateTime effectiveDate;
  final String? source; // 'user', 'system', 'market'
  final String? notes;
  final int createdAt;

  const PriceHistory({
    this.id,
    required this.ingredientId,
    required this.price,
    this.currency = 'NGN',
    required this.effectiveDate,
    this.source,
    this.notes,
    required this.createdAt,
  });

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      id: json['id'] as int?,
      ingredientId: json['ingredient_id'] as int,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'NGN',
      effectiveDate: DateTime.fromMillisecondsSinceEpoch(
        json['effective_date'] as int,
      ),
      source: json['source'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'ingredient_id': ingredientId,
      'price': price,
      'currency': currency,
      'effective_date': effectiveDate.millisecondsSinceEpoch,
      'source': source,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  PriceHistory copyWith({
    int? id,
    int? ingredientId,
    double? price,
    String? currency,
    DateTime? effectiveDate,
    String? source,
    String? notes,
    int? createdAt,
  }) {
    return PriceHistory(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'PriceHistory('
      'id: $id, '
      'ingredientId: $ingredientId, '
      'price: $price $currency, '
      'effectiveDate: $effectiveDate, '
      'source: $source)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceHistory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ingredientId == other.ingredientId &&
          price == other.price &&
          currency == other.currency &&
          effectiveDate == other.effectiveDate;

  @override
  int get hashCode =>
      id.hashCode ^
      ingredientId.hashCode ^
      price.hashCode ^
      currency.hashCode ^
      effectiveDate.hashCode;
}

/// Extension for JSON serialization of lists
extension PriceHistoryListExt on List<PriceHistory> {
  String toJsonString() => jsonEncode(map((e) => e.toJson()).toList());
}

List<PriceHistory> priceHistoryListFromJson(String str) =>
    (jsonDecode(str) as List).map((e) => PriceHistory.fromJson(e)).toList();
