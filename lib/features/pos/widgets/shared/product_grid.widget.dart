import 'package:flutter/material.dart';
import 'package:teste_flutter/features/catalog/entities/item_categoria.entity.dart';

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
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.black26),
            SizedBox(height: 8),
            Text('Nenhum produto encontrado'),
          ],
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250.0,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      
      itemBuilder: (context, index) {},
    );
  }
}
