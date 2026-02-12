import 'cost_item.dart';

/// Product category for home textiles
enum ProductCategory { bedding, bath, kitchen, decor }

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.bedding:
        return 'Bedding';
      case ProductCategory.bath:
        return 'Bath';
      case ProductCategory.kitchen:
        return 'Kitchen';
      case ProductCategory.decor:
        return 'Decor';
    }
  }

  String get icon {
    switch (this) {
      case ProductCategory.bedding:
        return '🛏️';
      case ProductCategory.bath:
        return '🛁';
      case ProductCategory.kitchen:
        return '🍽️';
      case ProductCategory.decor:
        return '🪟';
    }
  }
}

/// Predefined product templates for common home textiles
class ProductTemplate {
  final String id;
  final String name;
  final ProductCategory category;
  final String description;
  final Map<IndustryScale, List<CostItemTemplate>> costTemplates;

  const ProductTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.costTemplates,
  });
}

/// Template for cost items with default values
class CostItemTemplate {
  final String name;
  final String unit;
  final double defaultQuantity;
  final double defaultRate;
  final bool isRequired;

  const CostItemTemplate({
    required this.name,
    required this.unit,
    this.defaultQuantity = 0,
    this.defaultRate = 0,
    this.isRequired = true,
  });

  CostItem toCostItem({double? quantity, double? rate}) {
    return CostItem(
      name: name,
      quantity: quantity ?? defaultQuantity,
      unit: unit,
      ratePerUnit: rate ?? defaultRate,
    );
  }
}

/// All available product templates
final List<ProductTemplate> productTemplates = [
  // ══════════════════════════════════════════════════════════════
  // BEDDING PRODUCTS
  // ══════════════════════════════════════════════════════════════
  ProductTemplate(
    id: 'bedsheet',
    name: 'Bedsheet',
    category: ProductCategory.bedding,
    description: 'Flat or fitted bedsheets in various sizes',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'sqm',
          defaultQuantity: 5.2,
          defaultRate: 46,
        ),
        CostItemTemplate(
          name: 'Weaving',
          unit: 'min',
          defaultQuantity: 12,
          defaultRate: 0.10,
        ),
        CostItemTemplate(
          name: 'Dyeing/Printing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 45,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'min',
          defaultQuantity: 1,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'min',
          defaultQuantity: 4,
          defaultRate: 0.15,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 240,
        ),
        CostItemTemplate(
          name: 'Dyeing/Printing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 40,
        ),
        CostItemTemplate(
          name: 'Labor (Cut + Stitch)',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 75,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 240,
        ),
        CostItemTemplate(
          name: 'Dye/Print Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 35,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 50,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 240,
        ),
        CostItemTemplate(
          name: 'Tailor Charge',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 40,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
      ],
    },
  ),

  ProductTemplate(
    id: 'pillow_cover',
    name: 'Pillow Cover',
    category: ProductCategory.bedding,
    description: 'Standard pillow covers with zip or envelope closure',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'sqm',
          defaultQuantity: 0.5,
          defaultRate: 50,
        ),
        CostItemTemplate(
          name: 'Weaving',
          unit: 'min',
          defaultQuantity: 3,
          defaultRate: 0.10,
        ),
        CostItemTemplate(
          name: 'Dyeing/Printing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'min',
          defaultQuantity: 0.5,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'min',
          defaultQuantity: 2,
          defaultRate: 0.15,
        ),
        CostItemTemplate(
          name: 'Zip/Closure',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 8,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'Dyeing/Printing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 12,
        ),
        CostItemTemplate(
          name: 'Labor (Cut + Stitch)',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'Zip/Trims',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 12,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 3,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 35,
        ),
        CostItemTemplate(
          name: 'Tailor Charge',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 2,
        ),
      ],
    },
  ),

  ProductTemplate(
    id: 'duvet_cover',
    name: 'Duvet/Quilt Cover',
    category: ProductCategory.bedding,
    description: 'Duvet covers with button or zip closure',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Fabric (Top + Bottom)',
          unit: 'sqm',
          defaultQuantity: 10,
          defaultRate: 48,
        ),
        CostItemTemplate(
          name: 'Weaving',
          unit: 'min',
          defaultQuantity: 20,
          defaultRate: 0.10,
        ),
        CostItemTemplate(
          name: 'Dyeing/Printing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 80,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'min',
          defaultQuantity: 2,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'min',
          defaultQuantity: 8,
          defaultRate: 0.15,
        ),
        CostItemTemplate(
          name: 'Buttons/Zip',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 35,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 480,
        ),
        CostItemTemplate(
          name: 'Dyeing/Printing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 70,
        ),
        CostItemTemplate(
          name: 'Labor (Cut + Stitch)',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 120,
        ),
        CostItemTemplate(
          name: 'Trims',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 480,
        ),
        CostItemTemplate(
          name: 'Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 60,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 100,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 500,
        ),
        CostItemTemplate(
          name: 'Tailor Charge',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 80,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
      ],
    },
  ),

  // ══════════════════════════════════════════════════════════════
  // BATH PRODUCTS
  // ══════════════════════════════════════════════════════════════
  ProductTemplate(
    id: 'bath_towel',
    name: 'Bath Towel',
    category: ProductCategory.bath,
    description: 'Terry cotton bath towels',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Yarn',
          unit: 'kg',
          defaultQuantity: 0.5,
          defaultRate: 220,
        ),
        CostItemTemplate(
          name: 'Weaving',
          unit: 'min',
          defaultQuantity: 8,
          defaultRate: 0.10,
        ),
        CostItemTemplate(
          name: 'Dyeing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'min',
          defaultQuantity: 0.5,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'Stitching (Hem)',
          unit: 'min',
          defaultQuantity: 2,
          defaultRate: 0.15,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Yarn',
          unit: 'kg',
          defaultQuantity: 0.5,
          defaultRate: 200,
        ),
        CostItemTemplate(
          name: 'Weaving + Dyeing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 50,
        ),
        CostItemTemplate(
          name: 'Labor',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Raw Towel (Grey)',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 100,
        ),
        CostItemTemplate(
          name: 'Dyeing Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Finishing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Ready Towel',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 120,
        ),
        CostItemTemplate(
          name: 'Embroidery/Finishing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
      ],
    },
  ),

  ProductTemplate(
    id: 'bath_mat',
    name: 'Bath Mat',
    category: ProductCategory.bath,
    description: 'Non-slip bath mats',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Yarn',
          unit: 'kg',
          defaultQuantity: 0.8,
          defaultRate: 180,
        ),
        CostItemTemplate(
          name: 'Weaving/Tufting',
          unit: 'min',
          defaultQuantity: 10,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'Dyeing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Backing + Anti-slip',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'min',
          defaultQuantity: 1,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 12,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Material',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 150,
        ),
        CostItemTemplate(
          name: 'Processing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 40,
        ),
        CostItemTemplate(
          name: 'Anti-slip Backing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Grey Mat',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 150,
        ),
        CostItemTemplate(
          name: 'Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 8,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Ready Mat',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 180,
        ),
        CostItemTemplate(
          name: 'Finishing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
      ],
    },
  ),

  // ══════════════════════════════════════════════════════════════
  // KITCHEN PRODUCTS
  // ══════════════════════════════════════════════════════════════
  ProductTemplate(
    id: 'kitchen_towel',
    name: 'Kitchen Towel',
    category: ProductCategory.kitchen,
    description: 'Kitchen towels - waffle weave, terry, etc.',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Yarn',
          unit: 'kg',
          defaultQuantity: 0.08,
          defaultRate: 220,
        ),
        CostItemTemplate(
          name: 'Weaving',
          unit: 'mtr',
          defaultQuantity: 0.5,
          defaultRate: 8,
        ),
        CostItemTemplate(
          name: 'Dyeing',
          unit: 'mtr',
          defaultQuantity: 0.5,
          defaultRate: 35,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 0.80,
        ),
        CostItemTemplate(
          name: 'Stitching (Hem)',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 1.50,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 2.50,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Yarn',
          unit: 'kg',
          defaultQuantity: 0.08,
          defaultRate: 200,
        ),
        CostItemTemplate(
          name: 'Weaving + Dyeing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Labor',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 3,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 2,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Grey Cloth',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 18,
        ),
        CostItemTemplate(
          name: 'Dyeing Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 8,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 3,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 1,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 1,
        ),
      ],
    },
  ),

  ProductTemplate(
    id: 'table_mat',
    name: 'Table Mat / Placemat',
    category: ProductCategory.kitchen,
    description: 'Woven or printed table mats',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Yarn',
          unit: 'kg',
          defaultQuantity: 0.05,
          defaultRate: 180,
        ),
        CostItemTemplate(
          name: 'Weaving',
          unit: 'mtr',
          defaultQuantity: 0.2,
          defaultRate: 6,
        ),
        CostItemTemplate(
          name: 'Dyeing',
          unit: 'mtr',
          defaultQuantity: 0.2,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 0.50,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 1.00,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 1.80,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Material',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 12,
        ),
        CostItemTemplate(
          name: 'Processing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 8,
        ),
        CostItemTemplate(
          name: 'Labor',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 4,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 2,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Grey Mat',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
        CostItemTemplate(
          name: 'Finishing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 3,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 1,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 18,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 1,
        ),
      ],
    },
  ),

  ProductTemplate(
    id: 'apron',
    name: 'Apron',
    category: ProductCategory.kitchen,
    description: 'Kitchen aprons with pockets',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 1.2,
          defaultRate: 80,
        ),
        CostItemTemplate(
          name: 'Printing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 2,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Straps/Trims',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 8,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 1.2,
          defaultRate: 75,
        ),
        CostItemTemplate(
          name: 'Processing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'Labor',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'Trims + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 1.2,
          defaultRate: 70,
        ),
        CostItemTemplate(
          name: 'Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 12,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 1.2,
          defaultRate: 75,
        ),
        CostItemTemplate(
          name: 'Tailor Charge',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 3,
        ),
      ],
    },
  ),

  // ══════════════════════════════════════════════════════════════
  // DECOR PRODUCTS
  // ══════════════════════════════════════════════════════════════
  ProductTemplate(
    id: 'curtain',
    name: 'Curtain',
    category: ProductCategory.decor,
    description: 'Window curtains - plain or printed',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 3,
          defaultRate: 150,
        ),
        CostItemTemplate(
          name: 'Weaving',
          unit: 'min',
          defaultQuantity: 15,
          defaultRate: 0.10,
        ),
        CostItemTemplate(
          name: 'Dyeing/Printing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 100,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'min',
          defaultQuantity: 2,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'Stitching + Pleating',
          unit: 'min',
          defaultQuantity: 10,
          defaultRate: 0.15,
        ),
        CostItemTemplate(
          name: 'Rings/Hooks',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 40,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 3,
          defaultRate: 140,
        ),
        CostItemTemplate(
          name: 'Processing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 80,
        ),
        CostItemTemplate(
          name: 'Labor',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 100,
        ),
        CostItemTemplate(
          name: 'Accessories + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 50,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 3,
          defaultRate: 130,
        ),
        CostItemTemplate(
          name: 'Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 60,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 80,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 3,
          defaultRate: 140,
        ),
        CostItemTemplate(
          name: 'Tailor Charge',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 80,
        ),
        CostItemTemplate(
          name: 'Rings/Hooks',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
      ],
    },
  ),

  ProductTemplate(
    id: 'cushion_cover',
    name: 'Cushion Cover',
    category: ProductCategory.decor,
    description: 'Decorative cushion covers',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'sqm',
          defaultQuantity: 0.4,
          defaultRate: 120,
        ),
        CostItemTemplate(
          name: 'Printing/Embroidery',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 35,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'min',
          defaultQuantity: 0.5,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'min',
          defaultQuantity: 3,
          defaultRate: 0.15,
        ),
        CostItemTemplate(
          name: 'Zip',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 8,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 50,
        ),
        CostItemTemplate(
          name: 'Processing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 30,
        ),
        CostItemTemplate(
          name: 'Labor',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Trims + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 50,
        ),
        CostItemTemplate(
          name: 'Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 55,
        ),
        CostItemTemplate(
          name: 'Tailor Charge',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 3,
        ),
      ],
    },
  ),

  ProductTemplate(
    id: 'table_runner',
    name: 'Table Runner',
    category: ProductCategory.decor,
    description: 'Decorative table runners',
    costTemplates: {
      IndustryScale.large: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 1.5,
          defaultRate: 100,
        ),
        CostItemTemplate(
          name: 'Weaving',
          unit: 'min',
          defaultQuantity: 8,
          defaultRate: 0.10,
        ),
        CostItemTemplate(
          name: 'Dyeing/Embroidery',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 40,
        ),
        CostItemTemplate(
          name: 'Cutting',
          unit: 'min',
          defaultQuantity: 1,
          defaultRate: 0.12,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'min',
          defaultQuantity: 4,
          defaultRate: 0.15,
        ),
        CostItemTemplate(
          name: 'QC + Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 15,
        ),
      ],
      IndustryScale.medium: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 1.5,
          defaultRate: 90,
        ),
        CostItemTemplate(
          name: 'Processing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 35,
        ),
        CostItemTemplate(
          name: 'Labor',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 10,
        ),
      ],
      IndustryScale.small: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 1.5,
          defaultRate: 85,
        ),
        CostItemTemplate(
          name: 'Job Work',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Stitching',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 20,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 5,
        ),
      ],
      IndustryScale.extraSmall: [
        CostItemTemplate(
          name: 'Fabric',
          unit: 'mtr',
          defaultQuantity: 1.5,
          defaultRate: 90,
        ),
        CostItemTemplate(
          name: 'Tailor Charge',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 25,
        ),
        CostItemTemplate(
          name: 'Packing',
          unit: 'pcs',
          defaultQuantity: 1,
          defaultRate: 3,
        ),
      ],
    },
  ),
];

/// Get product templates by category
List<ProductTemplate> getProductsByCategory(ProductCategory category) {
  return productTemplates.where((p) => p.category == category).toList();
}

/// Get a product template by ID
ProductTemplate? getProductById(String id) {
  try {
    return productTemplates.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}
