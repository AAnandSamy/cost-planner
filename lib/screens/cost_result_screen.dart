import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cost_item.dart';

class CostResultScreen extends StatelessWidget {
  final CostResult result;

  const CostResultScreen({super.key, required this.result});

  Color _getScaleColor() {
    switch (result.scale) {
      case IndustryScale.large:
        return Colors.blue;
      case IndustryScale.medium:
        return Colors.green;
      case IndustryScale.small:
        return Colors.orange;
      case IndustryScale.extraSmall:
        return Colors.amber.shade700;
    }
  }

  String _formatIndian(double value) {
    String numStr = value.toStringAsFixed(2);
    List<String> parts = numStr.split('.');
    String intPart = parts[0];
    String decPart = parts.length > 1 ? '.${parts[1]}' : '';

    if (intPart.length <= 3) return numStr;

    String last3 = intPart.substring(intPart.length - 3);
    String remaining = intPart.substring(0, intPart.length - 3);

    String formatted = '';
    for (int i = remaining.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 2 == 0) {
        formatted = ',$formatted';
      }
      formatted = remaining[i] + formatted;
    }

    return '$formatted,$last3$decPart';
  }

  @override
  Widget build(BuildContext context) {
    final scaleColor = _getScaleColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost Breakdown'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy Summary',
            onPressed: () => _copyToClipboard(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(scaleColor),
            const SizedBox(height: 24),

            // Cost Items Table
            _buildCostItemsCard(scaleColor),
            const SizedBox(height: 24),

            // Adjustments
            _buildAdjustmentsCard(scaleColor),
            const SizedBox(height: 24),

            // Final Summary
            _buildFinalSummaryCard(scaleColor),
            const SizedBox(height: 24),

            // Cost Distribution Chart
            _buildDistributionCard(scaleColor),
            const SizedBox(height: 24),

            // Formula Reference
            _buildFormulaCard(scaleColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Color scaleColor) {
    return Card(
      color: scaleColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scaleColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scaleColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                result.scale.emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.productName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.scale.displayName,
                    style: TextStyle(
                      color: scaleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: ${result.quantity} pcs',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostItemsCard(Color scaleColor) {
    final activeItems = result.items.where((i) => i.total > 0).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, color: scaleColor),
                const SizedBox(width: 8),
                const Text(
                  'Cost Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: scaleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Qty',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Unit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Rate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...activeItems.map(_buildItemRow),
            if (activeItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No cost items with values'),
              ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${_formatIndian(result.subtotal)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: scaleColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(CostItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(item.name, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.quantity % 1 == 0
                  ? item.quantity.toInt().toString()
                  : item.quantity.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.unit,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${item.ratePerUnit.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${_formatIndian(item.total)}',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentsCard(Color scaleColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: scaleColor),
                const SizedBox(width: 8),
                const Text(
                  'Adjustments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _adjustmentRow(
              'Wastage',
              result.wastagePercent,
              result.wastageAmount,
              Colors.red.shade400,
            ),
            const SizedBox(height: 8),
            _adjustmentRow(
              'Overhead',
              result.overheadPercent,
              result.overheadAmount,
              Colors.purple.shade400,
            ),
            const SizedBox(height: 8),
            _adjustmentRow(
              'Profit Margin',
              result.profitPercent,
              result.profitAmount,
              Colors.green.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _adjustmentRow(
    String label,
    double percent,
    double amount,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(
          '${percent.toStringAsFixed(1)}%',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(width: 16),
        Text(
          '₹${_formatIndian(amount)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildFinalSummaryCard(Color scaleColor) {
    return Card(
      color: scaleColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Per Piece Cost',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${result.perPieceCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Total Order Value',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${_formatIndian(result.totalCost)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionCard(Color scaleColor) {
    final activeItems = result.items.where((i) => i.total > 0).toList();
    if (activeItems.isEmpty) return const SizedBox.shrink();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart_outline, color: scaleColor),
                const SizedBox(width: 8),
                const Text(
                  'Cost Distribution',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...activeItems.map((item) {
              final percent =
                  result.subtotal > 0 ? (item.total / result.subtotal) : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name, style: const TextStyle(fontSize: 13)),
                        Text(
                          '${(percent * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percent,
                      backgroundColor: Colors.grey.shade200,
                      color: _getItemColor(item.name),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getItemColor(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('yarn') ||
        lowerName.contains('fabric') ||
        lowerName.contains('material')) {
      return Colors.brown;
    }
    if (lowerName.contains('weaving')) return Colors.blue;
    if (lowerName.contains('dye') || lowerName.contains('dyeing'))
      return Colors.purple;
    if (lowerName.contains('print')) return Colors.pink;
    if (lowerName.contains('cut')) return Colors.orange;
    if (lowerName.contains('stitch') ||
        lowerName.contains('sewing') ||
        lowerName.contains('labor') ||
        lowerName.contains('tailor')) {
      return Colors.teal;
    }
    if (lowerName.contains('qc') || lowerName.contains('quality'))
      return Colors.green;
    if (lowerName.contains('pack')) return Colors.amber;
    if (lowerName.contains('job')) return Colors.indigo;
    return Colors.grey;
  }

  Widget _buildFormulaCard(Color scaleColor) {
    return Card(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.functions, color: scaleColor),
                const SizedBox(width: 8),
                const Text(
                  'Formula Applied',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                'Total = (Subtotal × Wastage%) × Overhead% × Profit%\nPer Piece = Total ÷ Quantity',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Scale: ${result.scale.displayName}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('TEX COST PRO - COST SUMMARY');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('Product: ${result.productName}');
    buffer.writeln('Scale: ${result.scale.displayName}');
    buffer.writeln('Quantity: ${result.quantity} pcs');
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln('COST BREAKDOWN:');
    for (final item in result.items.where((i) => i.total > 0)) {
      buffer.writeln('  ${item.name}: ₹${_formatIndian(item.total)}');
    }
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln('Subtotal: ₹${_formatIndian(result.subtotal)}');
    buffer.writeln(
      'Wastage (${result.wastagePercent}%): ₹${_formatIndian(result.wastageAmount)}',
    );
    buffer.writeln(
      'Overhead (${result.overheadPercent}%): ₹${_formatIndian(result.overheadAmount)}',
    );
    buffer.writeln(
      'Profit (${result.profitPercent}%): ₹${_formatIndian(result.profitAmount)}',
    );
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln('TOTAL COST: ₹${_formatIndian(result.totalCost)}');
    buffer.writeln('PER PIECE: ₹${result.perPieceCost.toStringAsFixed(2)}');
    buffer.writeln('═══════════════════════════════════════');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cost summary copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
