import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/pos/stores/filtered_catalog.store.dart';
import 'package:teste_flutter/features/pos/widgets/desktop/category_list.widget.dart';
import 'package:teste_flutter/shared/widgets/search_input.widget.dart';
import 'package:teste_flutter/utils/extension_methos/extension_methods.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, required this.storeName});

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
    const filterButtonBorder = Color.fromRGBO(0, 0, 0, 0.1);
    return Observer(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Row(
            children: [
              // Back button
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

              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Criando pedido',
                      style: context.textTheme.titleMedium,
                    ),
                    Text(
                      'Loja: ${widget.storeName.capitalizeFirstLetter()}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
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
        body: const CategoryList(),
      );
    });
  }
}

