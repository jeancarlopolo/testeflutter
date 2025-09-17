import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/catalog/entities/capa.entity.dart';
import 'package:teste_flutter/features/catalog/entities/category.entity.dart';
import 'package:teste_flutter/features/pos/stores/filtered_catalog.store.dart';
import 'package:teste_flutter/features/pos/widgets/shared/category_card.widget.dart';

class MobileCategoryList extends StatefulWidget {
  const MobileCategoryList({super.key});

  @override
  State<MobileCategoryList> createState() => _MobileCategoryListState();
}

class _MobileCategoryListState extends State<MobileCategoryList> {
  @override
  void initState() {
    super.initState();
    filteredCatalogStore = GetIt.I<FilteredCatalogStore>();
  }

  late final FilteredCatalogStore filteredCatalogStore;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final categories = filteredCatalogStore.filteredCategories;
        final selectedCategory = filteredCatalogStore.selectedCategory;

        return SizedBox(
          height: 88.0, 
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16.0),
            itemBuilder: (context, index) {
              final category = categories[index];

              Color? textColor, backgroundColor;
              DecorationImage? image;

              switch (category.capa) {
                case CapaCor(:final corFundo, :final corFonte):
                  backgroundColor = Color(int.parse('0xff${corFundo.substring(1)}'));
                  textColor = Color(int.parse('0xff${corFonte.substring(1)}'));
                case CapaImagem(:final corFonteDefault, :final defaultUrl):
                  textColor = Color(int.parse('0xff${corFonteDefault?.substring(1)}'));
                  image = DecorationImage(
                    image: NetworkImage(defaultUrl ?? ''),
                    fit: BoxFit.cover,
                  );
              }

              return GestureDetector(
                onTap: () {
                  if (selectedCategory?.id == category.id) {
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
                  isSelected: selectedCategory?.id == category.id,
                  mobile: true,
                ),
              );
            },
          ),
        );
      },
    );
  }
}