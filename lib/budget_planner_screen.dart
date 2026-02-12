import 'package:flutter/material.dart';
import 'budget_detail_screen.dart';

class BudgetPlannerScreen extends StatefulWidget {
  final Order? order;

  const BudgetPlannerScreen({super.key, this.order});

  @override
  State<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  Order? _selectedOrder;

  // Yarn consumption fields
  final _warpCountController = TextEditingController();
  final _weftCountController = TextEditingController();
  final _reedPickController = TextEditingController();
  final _fabricWidthController = TextEditingController();
  final _fabricLengthController = TextEditingController();
  final _shrinkageController = TextEditingController(text: '5');
  final _yarnKgController = TextEditingController();
  final _yarnRateController = TextEditingController();

  // Editable cost rows
  final List<_CostRow> _costRows = [];

  // Profit
  double _profitPercent = 15;

  @override
  void initState() {
    super.initState();
    _selectedOrder = widget.order;

    // Pre-fill if an existing budget matches this order
    if (_selectedOrder != null) {
      final existing = sampleBudgets.where((b) => b.orderId == _selectedOrder!.orderId).toList();
      if (existing.isNotEmpty) {
        _prefillFromBudget(existing.first);
      } else {
        _addDefaultCostRows();
      }
    } else {
      _addDefaultCostRows();
    }
  }

  void _prefillFromBudget(OrderBudget budget) {
    _warpCountController.text = budget.yarnCountWarp;
    _weftCountController.text = budget.yarnCountWeft;
    _reedPickController.text = budget.reedPick;
    _fabricWidthController.text = budget.fabricWidthCm.toString();
    _fabricLengthController.text = budget.fabricLengthMtr.toString();
    _shrinkageController.text = budget.shrinkagePercent.toString();
    _yarnKgController.text = budget.yarnQuantityKg.toString();
    _yarnRateController.text = budget.yarnRatePerKg.toString();
    _profitPercent = budget.profitPercentage;
    _costRows.clear();
    for (final item in budget.lineItems) {
      _costRows.add(_CostRow(
        process: item.process,
        qtyController: TextEditingController(text: item.quantity.toString()),
        unit: item.unit,
        rateController: TextEditingController(text: item.ratePerUnit.toString()),
      ));
    }
  }

  void _addDefaultCostRows() {
    final defaults = [
      ('Yarn Purchase', 'kg'),
      ('Sizing & Weaving', 'mtr'),
      ('Dyeing', 'mtr'),
      ('Printing', 'mtr'),
      ('Special Process', 'mtr'),
      ('Lab Testing', 'lot'),
      ('Cutting', 'pcs'),
      ('Stitching', 'pcs'),
      ('QC Charges', 'pcs'),
      ('Packing & Accessories', 'pcs'),
      ('Logistics', 'lot'),
    ];
    for (final d in defaults) {
      _costRows.add(_CostRow(
        process: d.$1,
        qtyController: TextEditingController(text: '0'),
        unit: d.$2,
        rateController: TextEditingController(text: '0'),
      ));
    }
  }

  double _getRowTotal(_CostRow row) {
    final qty = double.tryParse(row.qtyController.text) ?? 0;
    final rate = double.tryParse(row.rateController.text) ?? 0;
    return qty * rate;
  }

  double get _subtotal => _costRows.fold(0.0, (sum, row) => sum + _getRowTotal(row));
  double get _profitAmount => _subtotal * (_profitPercent / 100);
  double get _totalCost => _subtotal + _profitAmount;
  double get _perPieceCost {
    final qty = _selectedOrder?.quantity ?? 1;
    return qty > 0 ? _totalCost / qty : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Planner'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section 1: Order Summary ──────────────────────────
              const Text('Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildOrderSelector(),
              if (_selectedOrder != null) ...[
                const SizedBox(height: 8),
                _buildOrderInfoCard(_selectedOrder!),
              ],
              const SizedBox(height: 24),

              // ── Section 2: Yarn Consumption ───────────────────────
              const Text('Yarn Consumption', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildYarnSection(),
              const SizedBox(height: 24),

              // ── Section 3: Cost Breakdown ─────────────────────────
              const Text('Cost Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildCostTable(),
              const SizedBox(height: 24),

              // ── Section 4: Summary ────────────────────────────────
              _buildSummaryCard(),
              const SizedBox(height: 24),

              // ── Actions ───────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Budget Saved!')),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Budget'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectedOrder == null
                          ? null
                          : () {
                              final budget = _buildBudgetObject();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BudgetDetailScreen(budget: budget),
                                ),
                              );
                            },
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Summary'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // Order selector
  // ────────────────────────────────────────────────────────────────
  Widget _buildOrderSelector() {
    return DropdownButtonFormField<Order>(
      value: _selectedOrder,
      decoration: const InputDecoration(
        labelText: 'Select Order',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.assignment),
      ),
      items: sampleOrders.map((o) {
        return DropdownMenuItem(
          value: o,
          child: Text('${o.orderId} - ${o.product}'),
        );
      }).toList(),
      onChanged: (order) {
        setState(() {
          _selectedOrder = order;
          if (order != null) {
            final existing = sampleBudgets.where((b) => b.orderId == order.orderId).toList();
            if (existing.isNotEmpty) {
              _prefillFromBudget(existing.first);
            }
          }
        });
      },
    );
  }

  Widget _buildOrderInfoCard(Order order) {
    return Card(
      color: Colors.teal[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: _infoColumn('Product', order.product)),
            Expanded(child: _infoColumn('Size', order.size)),
            Expanded(child: _infoColumn('Qty', '${order.quantity} pcs')),
            Expanded(child: _infoColumn('Quality', order.quality)),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────
  // Yarn section
  // ────────────────────────────────────────────────────────────────
  Widget _buildYarnSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _smallField('Warp Count', _warpCountController, hint: 'e.g. 2/20s')),
                const SizedBox(width: 12),
                Expanded(child: _smallField('Weft Count', _weftCountController, hint: 'e.g. 10s')),
                const SizedBox(width: 12),
                Expanded(child: _smallField('Reed x Pick', _reedPickController, hint: 'e.g. 44x38')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _smallField('Fabric Width (cm)', _fabricWidthController, number: true)),
                const SizedBox(width: 12),
                Expanded(child: _smallField('Fabric Length (mtr)', _fabricLengthController, number: true)),
                const SizedBox(width: 12),
                Expanded(child: _smallField('Shrinkage %', _shrinkageController, number: true)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _smallField('Total Yarn (kg)', _yarnKgController, number: true)),
                const SizedBox(width: 12),
                Expanded(child: _smallField('Yarn Rate (₹/kg)', _yarnRateController, number: true)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Yarn Cost', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text(
                        '₹${_yarnCost.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
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

  double get _yarnCost {
    final kg = double.tryParse(_yarnKgController.text) ?? 0;
    final rate = double.tryParse(_yarnRateController.text) ?? 0;
    return kg * rate;
  }

  Widget _smallField(String label, TextEditingController ctrl, {bool number = false, String? hint}) {
    return TextField(
      controller: ctrl,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // Cost table
  // ────────────────────────────────────────────────────────────────
  Widget _buildCostTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
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
            const SizedBox(height: 4),
            ...List.generate(_costRows.length, (i) => _buildCostRowWidget(_costRows[i])),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRowWidget(_CostRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(row.process, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: row.qtyController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(row.unit, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: row.rateController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${_getRowTotal(row).toStringAsFixed(0)}',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // Summary card
  // ────────────────────────────────────────────────────────────────
  Widget _buildSummaryCard() {
    return Card(
      color: Colors.indigo[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Budget Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _summaryRow('Subtotal', '₹${_subtotal.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Profit'),
                Expanded(
                  child: Slider(
                    value: _profitPercent,
                    min: 0,
                    max: 40,
                    divisions: 40,
                    label: '${_profitPercent.toInt()}%',
                    onChanged: (v) => setState(() => _profitPercent = v),
                  ),
                ),
                Text('${_profitPercent.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            _summaryRow('Profit Amount', '₹${_profitAmount.toStringAsFixed(0)}'),
            const Divider(height: 24),
            _summaryRow('Total Cost', '₹${_totalCost.toStringAsFixed(0)}', bold: true, big: true),
            const SizedBox(height: 8),
            _summaryRow(
              'Per Piece Cost',
              '₹${_perPieceCost.toStringAsFixed(2)}',
              bold: true,
              big: true,
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false, bool big = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: big ? 16 : 14)),
        Text(
          value,
          style: TextStyle(
            fontSize: big ? 20 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────
  // Build the OrderBudget object from current form state
  // ────────────────────────────────────────────────────────────────
  OrderBudget _buildBudgetObject() {
    return OrderBudget(
      budgetId: 'BUD-NEW',
      orderId: _selectedOrder?.orderId ?? '',
      product: _selectedOrder?.product ?? '',
      orderQuantity: _selectedOrder?.quantity ?? 1,
      yarnCountWarp: _warpCountController.text,
      yarnCountWeft: _weftCountController.text,
      yarnQuantityKg: double.tryParse(_yarnKgController.text) ?? 0,
      yarnRatePerKg: double.tryParse(_yarnRateController.text) ?? 0,
      reedPick: _reedPickController.text,
      fabricWidthCm: double.tryParse(_fabricWidthController.text) ?? 0,
      fabricLengthMtr: double.tryParse(_fabricLengthController.text) ?? 0,
      shrinkagePercent: double.tryParse(_shrinkageController.text) ?? 0,
      profitPercentage: _profitPercent,
      lineItems: _costRows.map((row) {
        return BudgetLineItem(
          process: row.process,
          quantity: double.tryParse(row.qtyController.text) ?? 0,
          unit: row.unit,
          ratePerUnit: double.tryParse(row.rateController.text) ?? 0,
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _warpCountController.dispose();
    _weftCountController.dispose();
    _reedPickController.dispose();
    _fabricWidthController.dispose();
    _fabricLengthController.dispose();
    _shrinkageController.dispose();
    _yarnKgController.dispose();
    _yarnRateController.dispose();
    for (final row in _costRows) {
      row.qtyController.dispose();
      row.rateController.dispose();
    }
    super.dispose();
  }
}

// Helper class to hold editable cost row state
class _CostRow {
  final String process;
  final TextEditingController qtyController;
  final String unit;
  final TextEditingController rateController;

  _CostRow({
    required this.process,
    required this.qtyController,
    required this.unit,
    required this.rateController,
  });
}
