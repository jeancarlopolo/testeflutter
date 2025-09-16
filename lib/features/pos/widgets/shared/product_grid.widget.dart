import 'package:flutter/material.dart';
import 'package:teste_flutter/features/catalog/entities/item_categoria.entity.dart';
import 'package:teste_flutter/features/pos/widgets/shared/product_card.widget.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.items,
  });

  final List<ItemCategoria> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.black26),
            SizedBox(height: 8),
            Text('Nenhum produto encontrado'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16.0, 
        runSpacing: 16.0, 
        children: items.map((item) => ItemCard(item: item)).toList(),
      ),
    );
  }
}