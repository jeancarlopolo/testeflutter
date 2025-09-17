import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/catalog/entities/capa.entity.dart';
import 'package:teste_flutter/features/catalog/entities/category.entity.dart';
import 'package:teste_flutter/features/pos/stores/expand.store.dart';
import 'package:teste_flutter/features/pos/stores/filtered_catalog.store.dart';
import 'package:teste_flutter/features/pos/widgets/shared/category_card.widget.dart';
import 'package:teste_flutter/features/pos/widgets/shared/more_card.widget.dart';
import 'package:teste_flutter/features/pos/widgets/shared/product_grid.widget.dart';

class DesktopCategoryList extends StatefulWidget {
  const DesktopCategoryList({
    super.key,
  });

  @override
  State<DesktopCategoryList> createState() => _DesktopCategoryListState();
}

class _DesktopCategoryListState extends State<DesktopCategoryList> {
  @override
  void initState() {
    super.initState();
    filteredCatalogStore = GetIt.I<FilteredCatalogStore>();
    expandStore = GetIt.I<ExpandStore>();
  }

  late final FilteredCatalogStore filteredCatalogStore;
  late final ExpandStore expandStore;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      expandStore.isExpanded;
      filteredCatalogStore.filteredCategories;
      filteredCatalogStore.selectedCategory;
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double cardWidth = 152.0;
                const double horizontalSpacing = 16.0;
      
                final int itemsPerRow =
                    (constraints.maxWidth + horizontalSpacing) ~/
                        (cardWidth + horizontalSpacing);
      
                if (itemsPerRow == 0) {
                  return const SizedBox.shrink();
                }
      
                final int maxItemsForTwoRows = itemsPerRow * 2;
      
                List<Categoria> visibleCategories = [];
                List<Widget> visibleCards = [];
                if (expandStore.isExpanded) {
                  visibleCategories = filteredCatalogStore.filteredCategories;
                } else {
                  if (filteredCatalogStore.filteredCategories.length >=
                      maxItemsForTwoRows) {
                    visibleCategories = filteredCatalogStore
                        .filteredCategories
                        .take(maxItemsForTwoRows - 1)
                        .toList();
                  } else {
                    visibleCategories =
                        filteredCatalogStore.filteredCategories;
                  }
                }
                visibleCards = visibleCategories.map<Widget>((category) {
                  Color? textColor, backgroundColor;
                  DecorationImage? image;
      
                  switch (category.capa) {
                    case CapaCor(:final corFundo, :final corFonte):
                      backgroundColor =
                          Color(int.parse('0xff${corFundo.substring(1)}'));
                      textColor =
                          Color(int.parse('0xff${corFonte.substring(1)}'));
                    case CapaImagem(
                        :final corFonteDefault,
                        :final defaultUrl
                      ):
                      textColor = Color(
                          int.parse('0xff${corFonteDefault?.substring(1)}'));
                      image = DecorationImage(
                        image: NetworkImage(defaultUrl ?? ''),
                        fit: BoxFit.cover,
                      );
                  }
      
                  return GestureDetector(
                    onTap: () {
                      if (filteredCatalogStore.selectedCategory?.id ==
                          category.id) {
                        filteredCatalogStore.selectedCategory = null;
                      } else {
                        filteredCatalogStore.selectedCategory = category;
                      }
                    },
                    child: CategoryCard(
                      text: category.nome ?? '',
                      subtext: '${category.itens?.length ?? 0} produtos',
                      backgroundColor: backgroundColor,
                      textColor: textColor,
                      backgroundImage: image,
                      isSelected: filteredCatalogStore.selectedCategory?.id ==
                          category.id,
                      mobile: false,
                    ),
                  );
                }).toList();
      
                if (filteredCatalogStore.filteredCategories.length >
                    maxItemsForTwoRows) {
                  visibleCards.add(
                    MoreCard(store: expandStore),
                  );
                }
      
                return Wrap(
                  spacing: horizontalSpacing,
                  runSpacing: 16.0,
                  children: visibleCards,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
