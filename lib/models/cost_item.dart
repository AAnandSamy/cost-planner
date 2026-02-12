/// Represents a single cost line item in the costing breakdown
class CostItem {
  final String name;
  final double quantity;
  final String unit;
  final double ratePerUnit;
  final String? description;

  const CostItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.ratePerUnit,
    this.description,
  });

  double get total => quantity * ratePerUnit;

  CostItem copyWith({
    String? name,
    double? quantity,
    String? unit,
    double? ratePerUnit,
    String? description,
  }) {
    return CostItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      ratePerUnit: ratePerUnit ?? this.ratePerUnit,
      description: description ?? this.description,
    );
  }
}

/// Cost calculation result
class CostResult {
  final String productName;
  final IndustryScale scale;
  final List<CostItem> items;
  final double wastagePercent;
  final double overheadPercent;
  final double profitPercent;
  final int quantity;

  const CostResult({
    required this.productName,
    required this.scale,
    required this.items,
    required this.wastagePercent,
    required this.overheadPercent,
    required this.profitPercent,
    required this.quantity,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get wastageAmount => subtotal * (wastagePercent / 100);
  double get overheadAmount =>
      (subtotal + wastageAmount) * (overheadPercent / 100);
  double get profitAmount =>
      (subtotal + wastageAmount + overheadAmount) * (profitPercent / 100);
  double get totalCost =>
      subtotal + wastageAmount + overheadAmount + profitAmount;
  double get perPieceCost => quantity > 0 ? totalCost / quantity : 0;
}

/// Industry scale enum matching the README requirements
enum IndustryScale { large, medium, small, extraSmall }

extension IndustryScaleExtension on IndustryScale {
  String get displayName {
    switch (this) {
      case IndustryScale.large:
        return 'Large Scale';
      case IndustryScale.medium:
        return 'Medium Scale';
      case IndustryScale.small:
        return 'Small Scale';
      case IndustryScale.extraSmall:
        return 'Extra Small / Individual';
    }
  }

  String get description {
    switch (this) {
      case IndustryScale.large:
        return 'Export factories with detailed costing, BOM, routing & overhead absorption';
      case IndustryScale.medium:
        return 'Domestic manufacturers with simplified routing and % overhead';
      case IndustryScale.small:
        return 'Local factories using job-work rates and flat overhead';
      case IndustryScale.extraSmall:
        return 'Tailors & home units with basic material + labor costing';
    }
  }

  String get emoji {
    switch (this) {
      case IndustryScale.large:
        return '🟦';
      case IndustryScale.medium:
        return '🟩';
      case IndustryScale.small:
        return '🟧';
      case IndustryScale.extraSmall:
        return '🟨';
    }
  }

  double get defaultOverheadPercent {
    switch (this) {
      case IndustryScale.large:
        return 15.0;
      case IndustryScale.medium:
        return 12.0;
      case IndustryScale.small:
        return 5.0;
      case IndustryScale.extraSmall:
        return 0.0;
    }
  }

  double get defaultWastagePercent {
    switch (this) {
      case IndustryScale.large:
        return 5.0;
      case IndustryScale.medium:
        return 4.0;
      case IndustryScale.small:
        return 3.0;
      case IndustryScale.extraSmall:
        return 2.0;
    }
  }
}
