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
            expandedHeight: 180,
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
                        Icons.calculate_outlined,
                        size: 50,
                        color: Colors.white70,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Home Textile Costing Calculator',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
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
                    'What describes your business best?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This helps us show the right cost items for your setup',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const _SimplifiedScaleSelector(),
                  const SizedBox(height: 32),
                  const _QuickProducts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simplified scale selector with user-friendly descriptions
class _SimplifiedScaleSelector extends StatelessWidget {
  const _SimplifiedScaleSelector();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ScaleOptionCard(
          scale: IndustryScale.extraSmall,
          icon: Icons.person,
          title: 'Individual / Home Business',
          examples: 'Tailor, Etsy seller, Home crafter',
          features: [
            'Simple cost: Fabric + Labor',
            'No overhead tracking',
            'Quick estimation'
          ],
          color: Colors.amber,
        ),
        const SizedBox(height: 12),
        _ScaleOptionCard(
          scale: IndustryScale.small,
          icon: Icons.store,
          title: 'Small Workshop',
          examples: '1-10 workers, Local job work',
          features: [
            'Job-work rates',
            'Basic overhead',
            'Market-based pricing'
          ],
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        _ScaleOptionCard(
          scale: IndustryScale.medium,
          icon: Icons.factory_outlined,
          title: 'Medium Factory',
          examples: '10-100 workers, Multiple processes',
          features: [
            'BOM-based costing',
            'Overhead % allocation',
            'Process tracking'
          ],
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _ScaleOptionCard(
          scale: IndustryScale.large,
          icon: Icons.business,
          title: 'Large / Export Factory',
          examples: '100+ workers, Export orders',
          features: [
            'Full BOM + Routing',
            'Department overheads',
            'Detailed SMV costing'
          ],
          color: Colors.blue,
        ),
      ],
    );
  }
}

class _ScaleOptionCard extends StatelessWidget {
  final IndustryScale scale;
  final IconData icon;
  final String title;
  final String examples;
  final List<String> features;
  final Color color;

  const _ScaleOptionCard({
    required this.scale,
    required this.icon,
    required this.title,
    required this.examples,
    required this.features,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color.shade700, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color.shade700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      examples,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: features
                          .map((f) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  f,
                                  style: TextStyle(
                                      fontSize: 10, color: color.shade700),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
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
        Row(
          children: [
            const Icon(Icons.flash_on, size: 20, color: Colors.orange),
            const SizedBox(width: 6),
            const Text(
              'Quick Start',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Already know your product? Pick one to start calculating.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final product in productTemplates.take(8))
              ActionChip(
                avatar: Text(product.category.icon),
                label: Text(product.name),
                onPressed: () {
                  _showSimpleScaleSelector(context, product);
                },
              ),
          ],
        ),
      ],
    );
  }

  void _showSimpleScaleSelector(BuildContext context, ProductTemplate product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(product.category.icon,
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        product.description,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'What best describes your setup?',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 12),
            _buildScaleOption(
              context,
              product,
              IndustryScale.extraSmall,
              Icons.person,
              'Individual / Home',
              'Just me or a small team at home',
              Colors.amber,
            ),
            _buildScaleOption(
              context,
              product,
              IndustryScale.small,
              Icons.store,
              'Small Workshop',
              '1-10 workers, local job work',
              Colors.orange,
            ),
            _buildScaleOption(
              context,
              product,
              IndustryScale.medium,
              Icons.factory_outlined,
              'Medium Factory',
              '10-100 workers, own processes',
              Colors.green,
            ),
            _buildScaleOption(
              context,
              product,
              IndustryScale.large,
              Icons.business,
              'Large Factory',
              '100+ workers, export orders',
              Colors.blue,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleOption(
    BuildContext context,
    ProductTemplate product,
    IndustryScale scale,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductSelectionScreen(
                scale: scale,
                preselectedProduct: product,
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on Color {
  Color get shade700 => this;
}
