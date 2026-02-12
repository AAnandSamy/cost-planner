import 'package:flutter/material.dart';
import '../../models/budget.dart';

class BudgetDetailScreen extends StatelessWidget {
  final OrderBudget budget;

  const BudgetDetailScreen({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget - ${budget.orderId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Printing Budget...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing Quotation...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Order Info ──────────────────────────────────────────
              Card(
                color: Colors.teal[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.product,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _infoChip('Order', budget.orderId),
                          const SizedBox(width: 8),
                          _infoChip('Qty', '${budget.orderQuantity} pcs'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Yarn Details ────────────────────────────────────────
              const Text('Yarn & Fabric Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _detailRow('Warp Count', budget.yarnCountWarp),
                      _detailRow('Weft Count', budget.yarnCountWeft),
                      _detailRow('Reed x Pick', budget.reedPick),
                      _detailRow('Fabric Width', '${budget.fabricWidthCm} cm'),
                      _detailRow('Fabric Length', '${budget.fabricLengthMtr} mtr'),
                      _detailRow('Shrinkage', '${budget.shrinkagePercent}%'),
                      _detailRow('Yarn Quantity', '${budget.yarnQuantityKg} kg'),
                      _detailRow('Yarn Rate', '₹${budget.yarnRatePerKg}/kg'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Cost Breakdown Table ────────────────────────────────
              const Text('Cost Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: Text('Process', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                            Expanded(flex: 1, child: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text('Rate (₹)', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text('Total (₹)', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
                          ],
                        ),
                      ),
                      ...budget.lineItems.map(_buildLineItemRow),
                      const Divider(height: 24),
                      _totalRow('Subtotal', budget.subtotal),
                      const SizedBox(height: 4),
                      _totalRow('Profit (${budget.profitPercentage.toInt()}%)', budget.profitAmount),
                      const Divider(height: 24),
                      _totalRow('Total Cost', budget.totalCost, bold: true, big: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Per Piece Summary ───────────────────────────────────
              Card(
                color: Colors.indigo[900],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Per Piece Cost', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            '₹${budget.perPieceCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Total Order Value', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            '₹${_formatIndian(budget.totalCost)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Cost Distribution (Simple Bar Chart) ────────────────
              const Text('Cost Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: budget.lineItems.where((item) => item.total > 0).map((item) {
                      double percent = budget.subtotal > 0 ? (item.total / budget.subtotal) : 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.process, style: const TextStyle(fontSize: 13)),
                                Text('${(percent * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: percent,
                              backgroundColor: Colors.grey[200],
                              color: _getBarColor(item.process),
                              minHeight: 10,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$label: $value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: TextStyle(color: Colors.grey[700]))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLineItemRow(BudgetLineItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(item.process, style: const TextStyle(fontSize: 13))),
          Expanded(
            flex: 2,
            child: Text(
              item.quantity % 1 == 0 ? item.quantity.toInt().toString() : item.quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(flex: 1, child: Text(item.unit, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
          Expanded(flex: 2, child: Text('₹${item.ratePerUnit}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
          Expanded(flex: 2, child: Text('₹${item.total.toStringAsFixed(0)}', textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double value, {bool bold = false, bool big = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: big ? 16 : 14, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(
            '₹${_formatIndian(value)}',
            style: TextStyle(fontSize: big ? 18 : 14, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Color _getBarColor(String process) {
    if (process.contains('Yarn')) return Colors.brown;
    if (process.contains('Weaving')) return Colors.blue;
    if (process.contains('Dyeing')) return Colors.purple;
    if (process.contains('Printing')) return Colors.pink;
    if (process.contains('Cutting')) return Colors.orange;
    if (process.contains('Stitching')) return Colors.teal;
    if (process.contains('QC')) return Colors.green;
    if (process.contains('Packing')) return Colors.amber;
    if (process.contains('Lab')) return Colors.red;
    if (process.contains('Logistics')) return Colors.indigo;
    return Colors.grey;
  }

  /// Format number in Indian style: 9,56,225
  String _formatIndian(double value) {
    String numStr = value.toStringAsFixed(0);
    if (numStr.length <= 3) return numStr;

    String last3 = numStr.substring(numStr.length - 3);
    String remaining = numStr.substring(0, numStr.length - 3);

    final buffer = StringBuffer();
    for (int i = remaining.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(remaining[remaining.length - 1 - (remaining.length - 1 - i)]);
    }

    // Reverse the buffer for remaining part
    String remainingFormatted = remaining.split('').reversed.toList().asMap().entries.map((e) {
      if (e.key > 0 && e.key % 2 == 0) return ',${e.value}';
      return e.value;
    }).join().split('').reversed.join();

    return '$remainingFormatted,$last3';
  }
}
