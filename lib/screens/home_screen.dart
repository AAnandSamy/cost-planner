import 'package:flutter/material.dart';
import '../models/cost_item.dart';
import '../models/product_template.dart';
import 'product_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Tex Cost Pro',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black38)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.indigo.shade700, Colors.indigo.shade400],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 60,
                        color: Colors.white70,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Home Textile Costing',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Your Industry Scale',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose the scale that best matches your business to get accurate cost calculations.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ...IndustryScale.values.map(
                    (scale) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ScaleCard(scale: scale),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _QuickProducts(),
                  const SizedBox(height: 32),
                  const _FormulaInfoCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleCard extends StatelessWidget {
  final IndustryScale scale;

  const _ScaleCard({required this.scale});

  Color _getScaleColor() {
    switch (scale) {
      case IndustryScale.large:
        return Colors.blue;
      case IndustryScale.medium:
        return Colors.green;
      case IndustryScale.small:
        return Colors.orange;
      case IndustryScale.extraSmall:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScaleColor();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductSelectionScreen(scale: scale),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    scale.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scale.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scale.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickProducts extends StatelessWidget {
  const _QuickProducts();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Start - Popular Products',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final product in productTemplates.take(6))
              ActionChip(
                avatar: Text(product.category.icon),
                label: Text(product.name),
                onPressed: () {
                  _showScaleSelector(context, product);
                },
              ),
          ],
        ),
      ],
    );
  }

  void _showScaleSelector(BuildContext context, ProductTemplate product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      product.category.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select your industry scale:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                ...IndustryScale.values.map(
                  (scale) => ListTile(
                    leading: Text(
                      scale.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    title: Text(scale.displayName),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductSelectionScreen(
                                scale: scale,
                                preselectedProduct: product,
                              ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }
}

class _FormulaInfoCard extends StatelessWidget {
  const _FormulaInfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.indigo.shade700),
                const SizedBox(width: 8),
                Text(
                  'Universal Cost Formula',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700,
                  ),
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
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: const Text(
                'Total Cost = Material + Processing + Labor + Overheads + Wastage',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The same formula applies to all scales—only the detail level changes.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Color {
  Color get shade700 => this;
}
