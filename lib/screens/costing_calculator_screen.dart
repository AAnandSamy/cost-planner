import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cost_item.dart';
import '../models/product_template.dart';

class CostingCalculatorScreen extends StatefulWidget {
  final IndustryScale scale;
  final ProductTemplate product;

  const CostingCalculatorScreen({
    super.key,
    required this.scale,
    required this.product,
  });

  @override
  State<CostingCalculatorScreen> createState() =>
      _CostingCalculatorScreenState();
}

class _CostingCalculatorScreenState extends State<CostingCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '100');

  late List<_CostRowData> _costRows;
  double _wastagePercent = 0;
  double _overheadPercent = 0;
  double _profitPercent = 15;

  @override
  void initState() {
    super.initState();
    _initializeCostRows();
    _wastagePercent = widget.scale.defaultWastagePercent;
    _overheadPercent = widget.scale.defaultOverheadPercent;
  }

  void _initializeCostRows() {
    final templates = widget.product.costTemplates[widget.scale] ?? [];
    _costRows =
        templates
            .map(
              (t) => _CostRowData(
                name: t.name,
                unit: t.unit,
                quantityController: TextEditingController(
                  text: t.defaultQuantity.toString(),
                ),
                rateController: TextEditingController(
                  text: t.defaultRate.toString(),
                ),
                isRequired: t.isRequired,
              ),
            )
            .toList();
  }

  Color _getScaleColor() {
    switch (widget.scale) {
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

  double _getRowTotal(_CostRowData row) {
    final qty = double.tryParse(row.quantityController.text) ?? 0;
    final rate = double.tryParse(row.rateController.text) ?? 0;
    return qty * rate;
  }

  double get _subtotal =>
      _costRows.fold(0.0, (sum, row) => sum + _getRowTotal(row));
  double get _wastageAmount => _subtotal * (_wastagePercent / 100);
  double get _overheadAmount =>
      (_subtotal + _wastageAmount) * (_overheadPercent / 100);
  double get _profitAmount =>
      (_subtotal + _wastageAmount + _overheadAmount) * (_profitPercent / 100);
  double get _totalCost =>
      _subtotal + _wastageAmount + _overheadAmount + _profitAmount;
  double get _perPieceCost {
    final qty = int.tryParse(_quantityController.text) ?? 1;
    return qty > 0 ? _totalCost / qty : 0;
  }

  void _addCustomRow() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final unitController = TextEditingController(text: 'pcs');
        return AlertDialog(
          title: const Text('Add Cost Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g., Special Embroidery',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  hintText: 'e.g., pcs, mtr, kg',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _costRows.add(
                      _CostRowData(
                        name: nameController.text,
                        unit:
                            unitController.text.isEmpty
                                ? 'pcs'
                                : unitController.text,
                        quantityController: TextEditingController(text: '0'),
                        rateController: TextEditingController(text: '0'),
                        isRequired: false,
                      ),
                    );
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeRow(int index) {
    setState(() {
      _costRows[index].dispose();
      _costRows.removeAt(index);
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    for (final row in _costRows) {
      row.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaleColor = _getScaleColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to defaults',
            onPressed: () {
              setState(() {
                for (final row in _costRows) {
                  row.dispose();
                }
                _initializeCostRows();
                _wastagePercent = widget.scale.defaultWastagePercent;
                _overheadPercent = widget.scale.defaultOverheadPercent;
                _profitPercent = 15;
              });
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Quantity
              _buildQuantitySection(scaleColor),
              const SizedBox(height: 24),

              // Cost Items Table
              _buildCostItemsSection(scaleColor),
              const SizedBox(height: 24),

              // Adjustments (Wastage, Overhead, Profit)
              _buildAdjustmentsSection(scaleColor),
              const SizedBox(height: 24),

              // Summary
              _buildSummaryCard(scaleColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySection(Color scaleColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Quantity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Number of pieces to calculate',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixText: 'pcs',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: scaleColor),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostItemsSection(Color scaleColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cost Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _addCustomRow,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                  SizedBox(
                    width: 40,
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
                  SizedBox(width: 32),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _costRows.length,
              (index) => _buildCostRow(_costRows[index], index, scaleColor),
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
                  '₹${_subtotal.toStringAsFixed(2)}',
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

  Widget _buildCostRow(_CostRowData row, int index, Color scaleColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(row.name, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: row.quantityController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              row.unit,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: row.rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                prefixText: '₹',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${_getRowTotal(row).toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          SizedBox(
            width: 32,
            child:
                !row.isRequired
                    ? IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        size: 18,
                        color: Colors.red.shade400,
                      ),
                      onPressed: () => _removeRow(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentsSection(Color scaleColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adjustments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Wastage
            _buildSliderRow(
              'Wastage',
              _wastagePercent,
              (v) => setState(() => _wastagePercent = v),
              0,
              15,
              _wastageAmount,
              scaleColor,
            ),
            const SizedBox(height: 12),
            // Overhead
            _buildSliderRow(
              'Overhead',
              _overheadPercent,
              (v) => setState(() => _overheadPercent = v),
              0,
              25,
              _overheadAmount,
              scaleColor,
            ),
            const SizedBox(height: 12),
            // Profit
            _buildSliderRow(
              'Profit Margin',
              _profitPercent,
              (v) => setState(() => _profitPercent = v),
              0,
              40,
              _profitAmount,
              scaleColor,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow(
    String label,
    double value,
    ValueChanged<double> onChanged,
    double min,
    double max,
    double amount,
    Color color, {
    bool isPrimary = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)}% = ₹${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isPrimary ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt() * 2,
          activeColor: isPrimary ? color : Colors.grey,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(Color scaleColor) {
    final quantity = int.tryParse(_quantityController.text) ?? 1;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scaleColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scaleColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.receipt_long, color: scaleColor, size: 22),
                const SizedBox(width: 10),
                const Text(
                  'Cost Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Base cost (Subtotal)
                _summaryDetailRow(
                  'Material & Labor',
                  _subtotal,
                  subtitle: 'Sum of all cost items above',
                  icon: Icons.inventory_2_outlined,
                  iconColor: Colors.blueGrey,
                ),
                const SizedBox(height: 14),

                // Wastage
                if (_wastagePercent > 0) ...[
                  _summaryDetailRow(
                    'Wastage',
                    _wastageAmount,
                    subtitle:
                        '${_wastagePercent.toStringAsFixed(1)}% of subtotal',
                    icon: Icons.delete_outline,
                    iconColor: Colors.red.shade400,
                    isAddition: true,
                  ),
                  const SizedBox(height: 14),
                ],

                // Overhead
                if (_overheadPercent > 0) ...[
                  _summaryDetailRow(
                    'Overhead',
                    _overheadAmount,
                    subtitle:
                        '${_overheadPercent.toStringAsFixed(1)}% of (subtotal + wastage)',
                    icon: Icons.business_outlined,
                    iconColor: Colors.purple.shade400,
                    isAddition: true,
                  ),
                  const SizedBox(height: 14),
                ],

                // Profit
                if (_profitPercent > 0) ...[
                  _summaryDetailRow(
                    'Profit Margin',
                    _profitAmount,
                    subtitle:
                        '${_profitPercent.toStringAsFixed(1)}% of cost before profit',
                    icon: Icons.trending_up,
                    iconColor: Colors.green.shade600,
                    isAddition: true,
                  ),
                  const SizedBox(height: 14),
                ],

                const Divider(height: 24, thickness: 1.5),

                // Total Cost
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Order Cost',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'For $quantity pieces',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${_totalCost.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: scaleColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Per Piece highlight
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [scaleColor, scaleColor.withOpacity(0.85)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cost Per Piece',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Your selling price reference',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹${_perPieceCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryDetailRow(
    String label,
    double value, {
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    bool isAddition = false,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        Text(
          '${isAddition ? '+ ' : ''}₹${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isAddition ? iconColor : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _CostRowData {
  final String name;
  final String unit;
  final TextEditingController quantityController;
  final TextEditingController rateController;
  final bool isRequired;

  _CostRowData({
    required this.name,
    required this.unit,
    required this.quantityController,
    required this.rateController,
    required this.isRequired,
  });

  void dispose() {
    quantityController.dispose();
    rateController.dispose();
  }
}
