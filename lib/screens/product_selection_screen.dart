import 'package:flutter/material.dart';
import '../models/cost_item.dart';
import '../models/product_template.dart';
import 'costing_calculator_screen.dart';

class ProductSelectionScreen extends StatefulWidget {
  final IndustryScale scale;
  final ProductTemplate? preselectedProduct;

  const ProductSelectionScreen({
    super.key,
    required this.scale,
    this.preselectedProduct,
  });

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ProductCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ProductCategory.values.length,
      vsync: this,
    );

    // If preselected product, navigate directly
    if (widget.preselectedProduct != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => CostingCalculatorScreen(
                  scale: widget.scale,
                  product: widget.preselectedProduct!,
                ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final scaleColor = _getScaleColor();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Product'),
            Text(
              widget.scale.displayName,
              style: TextStyle(
                fontSize: 12,
                color: scaleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: scaleColor,
          indicatorColor: scaleColor,
          tabs:
              ProductCategory.values
                  .map(
                    (cat) => Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cat.icon),
                          const SizedBox(width: 4),
                          Text(cat.displayName),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            ProductCategory.values.map((category) {
              final products = getProductsByCategory(category);
              return _buildProductList(products, scaleColor);
            }).toList(),
      ),
    );
  }

  Widget _buildProductList(List<ProductTemplate> products, Color scaleColor) {
    if (products.isEmpty) {
      return const Center(child: Text('No products in this category'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(
          product: product,
          scale: widget.scale,
          scaleColor: scaleColor,
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductTemplate product;
  final IndustryScale scale;
  final Color scaleColor;

  const _ProductCard({
    required this.product,
    required this.scale,
    required this.scaleColor,
  });

  @override
  Widget build(BuildContext context) {
    final costItems = product.costTemplates[scale] ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      CostingCalculatorScreen(scale: scale, product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scaleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.calculate_outlined, color: scaleColor),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Text(
                'Cost Components (${costItems.length})',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    costItems
                        .map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.name,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
