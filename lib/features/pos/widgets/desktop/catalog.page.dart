import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/catalog/entities/capa.entity.dart';
import 'package:teste_flutter/features/catalog/entities/category.entity.dart';
import 'package:teste_flutter/features/pos/stores/filtered_catalog.store.dart';
import 'package:teste_flutter/features/pos/widgets/shared/category_card.widget.dart';
import 'package:teste_flutter/features/pos/widgets/shared/more_card.widget.dart';
import 'package:teste_flutter/features/pos/widgets/shared/product_grid.widget.dart';
import 'package:teste_flutter/shared/widgets/search_input.widget.dart';
import 'package:teste_flutter/shared/widgets/secondary_button.widget.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage(
      {super.key, required this.categories, required this.storeName});

  final List<Categoria> categories;
  final String storeName;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  void initState() {
    super.initState();
    filteredCatalogStore = GetIt.I<FilteredCatalogStore>();
  }

  late final FilteredCatalogStore filteredCatalogStore;

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = context.colorScheme.onSurfaceVariant;
    const searchBarBackground = Color.fromRGBO(0, 0, 0, 0.06);
    const filterButtonBorder = Color.fromRGBO(0, 0, 0, 0.1);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        
        title: SizedBox(
          width: 496,
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 172,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: onSurfaceVariant,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        style: ButtonStyle(
                            side: WidgetStateProperty.all(
                                const BorderSide(color: Colors.transparent))),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Criando pedido',
                            style: context.textTheme.titleMedium,
                          ),
                          Text('Loja: ${widget.storeName}',
                              style: context.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SearchInput(
                  onChanged: (value) {
                    filteredCatalogStore.searchQuery = value ?? '';
                  },
                  placeholder: 'Buscar',
                  width: 200,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 104,
                height: 40,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list,
                      color: Colors.black, size: 24),
                  label: const Text(
                    'Filtrar',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 0.1,
                      color: Colors.black,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    side: const BorderSide(color: filterButtonBorder, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildCategorySection(),
            const SizedBox(height: 24),
            ProductGrid(items: filteredCatalogStore.filteredItems),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      width: 1024,
      height: 172,
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double cardWidth = 152.0;
          const double horizontalSpacing = 16.0;

          final int itemsPerRow = (constraints.maxWidth + horizontalSpacing) ~/
              (cardWidth + horizontalSpacing);

          if (itemsPerRow == 0) {
            return const SizedBox.shrink();
          }

          final int maxItemsForTwoRows = itemsPerRow * 2;

          List<Categoria> visibleCategories = [];
          List<Widget> visibleCards = [];

          if (widget.categories.length >= maxItemsForTwoRows) {
            visibleCategories =
                widget.categories.take(maxItemsForTwoRows - 1).toList();
          } else {
            visibleCategories = widget.categories;
          }

          visibleCards = visibleCategories.map((category) {
            Color? textColor, backgroundColor;
            DecorationImage? image;
            switch (category.capa) {
              case CapaCor(:final corFundo, :final corFonte):
                backgroundColor =
                    Color(int.parse('0xff${corFundo.substring(1)}'));
                textColor = Color(int.parse('0xff${corFonte.substring(1)}'));
              case CapaImagem(:final corFonteDefault, :final defaultUrl):
                textColor =
                    Color(int.parse('0xff${corFonteDefault?.substring(1)}'));
                image = DecorationImage(
                  image: NetworkImage(defaultUrl ?? ''),
                  fit: BoxFit.cover,
                );
            }
            return CategoryCard(
              text: category.nome ?? '',
              subtext: category.descricao ?? '',
              backgroundColor: backgroundColor,
              textColor: textColor,
              backgroundImage: image,
              isSelected:
                  filteredCatalogStore.selectedCategory?.id == category.id,
              mobile: false,
            );
          }).toList();

          return Wrap(
            spacing: horizontalSpacing,
            runSpacing: 16.0,
            children: visibleCards,
          );
        },
      ),
    );
  }
}
