class BudgetLineItem {
  final String process;
  final double quantity;
  final String unit; // 'kg', 'mtr', 'pcs', 'lot'
  final double ratePerUnit;

  BudgetLineItem({
    required this.process,
    required this.quantity,
    required this.unit,
    required this.ratePerUnit,
  });

  double get total => quantity * ratePerUnit;
}

class OrderBudget {
  final String budgetId;
  final String orderId;
  final String product;
  final int orderQuantity;

  // Yarn details
  final String yarnCountWarp;
  final String yarnCountWeft;
  final double yarnQuantityKg;
  final double yarnRatePerKg;
  final String reedPick;
  final double fabricWidthCm;
  final double fabricLengthMtr;
  final double shrinkagePercent;

  // Cost line items
  final List<BudgetLineItem> lineItems;

  // Profit
  final double profitPercentage;

  OrderBudget({
    required this.budgetId,
    required this.orderId,
    required this.product,
    required this.orderQuantity,
    required this.yarnCountWarp,
    required this.yarnCountWeft,
    required this.yarnQuantityKg,
    required this.yarnRatePerKg,
    required this.reedPick,
    required this.fabricWidthCm,
    required this.fabricLengthMtr,
    required this.shrinkagePercent,
    required this.lineItems,
    required this.profitPercentage,
  });

  double get subtotal => lineItems.fold(0.0, (sum, item) => sum + item.total);
  double get profitAmount => subtotal * (profitPercentage / 100);
  double get totalCost => subtotal + profitAmount;
  double get perPieceCost => totalCost / orderQuantity;
}

// ──────────────────────────────────────────────────────────────────
// Sample Budgets
// ──────────────────────────────────────────────────────────────────

final List<OrderBudget> sampleBudgets = [
  // Kitchen Towel (ORD-001) — 25,000 pcs, 50x70 cm, Waffle Weave
  OrderBudget(
    budgetId: 'BUD-001',
    orderId: 'ORD-001',
    product: 'Kitchen Towel (Waffle Weave)',
    orderQuantity: 25000,
    yarnCountWarp: '2/20s',
    yarnCountWeft: '10s',
    yarnQuantityKg: 1800,
    yarnRatePerKg: 220,
    reedPick: '44 x 38',
    fabricWidthCm: 160,
    fabricLengthMtr: 6000,
    shrinkagePercent: 8,
    profitPercentage: 15,
    lineItems: [
      BudgetLineItem(process: 'Yarn Purchase', quantity: 1800, unit: 'kg', ratePerUnit: 220),
      BudgetLineItem(process: 'Sizing & Weaving', quantity: 6000, unit: 'mtr', ratePerUnit: 8),
      BudgetLineItem(process: 'Dyeing (Indigo)', quantity: 6000, unit: 'mtr', ratePerUnit: 35),
      BudgetLineItem(process: 'Cutting', quantity: 25000, unit: 'pcs', ratePerUnit: 0.80),
      BudgetLineItem(process: 'Stitching (Hem)', quantity: 25000, unit: 'pcs', ratePerUnit: 1.50),
      BudgetLineItem(process: 'QC Charges', quantity: 25000, unit: 'pcs', ratePerUnit: 0.30),
      BudgetLineItem(process: 'Packing & Accessories', quantity: 25000, unit: 'pcs', ratePerUnit: 2.50),
      BudgetLineItem(process: 'Lab Testing', quantity: 1, unit: 'lot', ratePerUnit: 5000),
      BudgetLineItem(process: 'Logistics', quantity: 1, unit: 'lot', ratePerUnit: 50000),
    ],
  ),

  // Table Mat (ORD-002) — 50,000 pcs, 33x48 cm, Ribbed
  OrderBudget(
    budgetId: 'BUD-002',
    orderId: 'ORD-002',
    product: 'Table Mat (Ribbed)',
    orderQuantity: 50000,
    yarnCountWarp: '2/10s',
    yarnCountWeft: '2/10s',
    yarnQuantityKg: 2500,
    yarnRatePerKg: 180,
    reedPick: '36 x 32',
    fabricWidthCm: 120,
    fabricLengthMtr: 5000,
    shrinkagePercent: 5,
    profitPercentage: 15,
    lineItems: [
      BudgetLineItem(process: 'Yarn Purchase', quantity: 2500, unit: 'kg', ratePerUnit: 180),
      BudgetLineItem(process: 'Sizing & Weaving', quantity: 5000, unit: 'mtr', ratePerUnit: 6),
      BudgetLineItem(process: 'Dyeing', quantity: 5000, unit: 'mtr', ratePerUnit: 25),
      BudgetLineItem(process: 'Cutting', quantity: 50000, unit: 'pcs', ratePerUnit: 0.50),
      BudgetLineItem(process: 'Stitching', quantity: 50000, unit: 'pcs', ratePerUnit: 1.00),
      BudgetLineItem(process: 'QC Charges', quantity: 50000, unit: 'pcs', ratePerUnit: 0.25),
      BudgetLineItem(process: 'Packing & Accessories', quantity: 50000, unit: 'pcs', ratePerUnit: 1.80),
      BudgetLineItem(process: 'Lab Testing', quantity: 1, unit: 'lot', ratePerUnit: 3000),
      BudgetLineItem(process: 'Logistics', quantity: 1, unit: 'lot', ratePerUnit: 75000),
    ],
  ),
];
