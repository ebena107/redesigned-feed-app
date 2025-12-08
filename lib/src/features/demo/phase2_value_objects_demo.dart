import 'package:flutter/material.dart';
import 'package:feed_estimator/src/core/value_objects/value_objects.dart';

/// Demo page showcasing Phase 2 value objects
class Phase2ValueObjectsDemo extends StatefulWidget {
  const Phase2ValueObjectsDemo({super.key});

  @override
  State<Phase2ValueObjectsDemo> createState() => _Phase2ValueObjectsDemoState();
}

class _Phase2ValueObjectsDemoState extends State<Phase2ValueObjectsDemo> {
  late Price priceNGN;
  late Price priceUSD;
  late Weight weightKg;
  late Weight weightLbs;
  late Quantity quantity;

  @override
  void initState() {
    super.initState();
    _initializeValueObjects();
  }

  void _initializeValueObjects() {
    // Initialize Price value objects
    priceNGN = const Price(amount: 5000.50, currency: 'NGN');
    priceUSD = const Price(amount: 12.50, currency: 'USD');

    // Initialize Weight value objects
    weightKg = const Weight(value: 25.5, unit: WeightUnit.kg);
    weightLbs = const Weight(value: 56.2, unit: WeightUnit.lbs);

    // Initialize Quantity value object
    quantity = const Quantity(value: 100, unit: 'bags');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 2: Value Objects Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Price Value Object Demo
            _buildSectionCard(
              title: 'Price Value Object',
              content: [
                _buildDemoRow(
                  label: 'NGN Price',
                  value: priceNGN.format(),
                  details:
                      'Amount: ${priceNGN.amount}, Currency: ${priceNGN.currency}',
                ),
                _buildDemoRow(
                  label: 'USD Price',
                  value: priceUSD.format(),
                  details:
                      'Amount: ${priceUSD.amount}, Currency: ${priceUSD.currency}',
                ),
                const SizedBox(height: 12),
                _buildDemoRow(
                  label: 'Price Arithmetic',
                  value: '(NGN × 2)',
                  details:
                      '${priceNGN.format()} × 2 = ${(priceNGN * 2).format()}',
                ),
                _buildDemoRow(
                  label: 'Price Formatting',
                  value: 'Custom Decimals',
                  details: '${priceNGN.formatWithDecimals(0)} (no decimals)',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Weight Value Object Demo
            _buildSectionCard(
              title: 'Weight Value Object',
              content: [
                _buildDemoRow(
                  label: 'Weight in KG',
                  value: weightKg.format(),
                  details:
                      'Value: ${weightKg.value}, Unit: ${weightKg.unit.symbol}',
                ),
                _buildDemoRow(
                  label: 'Weight in LBS',
                  value: weightLbs.format(),
                  details:
                      'Value: ${weightLbs.value}, Unit: ${weightLbs.unit.symbol}',
                ),
                const SizedBox(height: 12),
                _buildDemoRow(
                  label: 'Unit Conversion',
                  value: 'KG to LBS',
                  details:
                      '${weightKg.format()} = ${weightKg.convertTo(WeightUnit.lbs).format()}',
                ),
                _buildDemoRow(
                  label: 'Unit Conversion',
                  value: 'LBS to KG',
                  details:
                      '${weightLbs.format()} = ${weightLbs.convertTo(WeightUnit.kg).format()}',
                ),
                _buildDemoRow(
                  label: 'Weight Math',
                  value: 'Addition',
                  details:
                      '${weightKg.format()} + ${weightLbs.convertTo(WeightUnit.kg).format()} = ${(weightKg + weightLbs.convertTo(WeightUnit.kg)).format()}',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quantity Value Object Demo
            _buildSectionCard(
              title: 'Quantity Value Object',
              content: [
                _buildDemoRow(
                  label: 'Quantity',
                  value: quantity.format(),
                  details: 'Value: ${quantity.value}, Unit: ${quantity.unit}',
                ),
                _buildDemoRow(
                  label: 'Quantity Math',
                  value: 'Multiplication',
                  details:
                      '${quantity.format()} × 2 = ${(quantity * 2).format()}',
                ),
                _buildDemoRow(
                  label: 'Quantity Arithmetic',
                  value: 'Division',
                  details:
                      '${quantity.format()} ÷ 4 = ${(quantity / 4).format()}',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Type Safety Benefits
            _buildBenefitsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> content,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 16),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildDemoRow({
    required String label,
    required String value,
    required String details,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            details,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    return Card(
      color: Colors.green.shade50,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✓ Type Safety Benefits',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green.shade800,
                  ),
            ),
            const SizedBox(height: 12),
            _buildBulletPoint('Prevents currency mismatches (NGN vs USD)'),
            _buildBulletPoint('Automatic unit conversion (kg, lbs, etc)'),
            _buildBulletPoint('Safe arithmetic operations with validation'),
            _buildBulletPoint('Immutable values with Equatable'),
            _buildBulletPoint('Database serialization (toMap/fromMap)'),
            _buildBulletPoint('Custom formatting for UI display'),
            _buildBulletPoint('Prevents invalid negative values'),
            _buildBulletPoint('Domain-driven design patterns'),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12, top: 2),
            child: Icon(Icons.check_circle, size: 16, color: Colors.green),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
