import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/pos/stores/filtered_catalog.store.dart';
import 'package:teste_flutter/features/pos/widgets/mobile/mobile_category_list.widget.dart';
import 'package:teste_flutter/features/pos/widgets/shared/product_grid.widget.dart';
import 'package:teste_flutter/shared/widgets/search_input.widget.dart';
import 'package:teste_flutter/utils/extension_methos/extension_methods.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

class MobileCatalogPage extends StatefulWidget {
  const MobileCatalogPage({super.key, required this.storeName});

  final String storeName;

  @override
  State<MobileCatalogPage> createState() => _MobileCatalogPageState();
}

class _MobileCatalogPageState extends State<MobileCatalogPage> {
  late final FilteredCatalogStore filteredCatalogStore;

  @override
  void initState() {
    super.initState();
    filteredCatalogStore = GetIt.I<FilteredCatalogStore>();
  }

  @override
  Widget build(BuildContext context) {
    const filterButtonBorder = Color.fromRGBO(0, 0, 0, 0.1);
    const iconColor = Color(0xFF49454F);

    // O AppBar gerencia a altura e o padding da status bar automaticamente.
    final appBar = AppBar(
      // Remove o botão de voltar padrão para usar o nosso
      automaticallyImplyLeading: false, 
      elevation: 0, // Remove a sombra padrão
      backgroundColor: Colors.white,
      // A parte de cima da sua AppBar antiga vai aqui no 'title'
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back, color: iconColor),
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
              Text(
                'Loja: ${widget.storeName.capitalizeFirstLetter()}',
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
      // A parte de baixo (busca) vai aqui, dentro de um PreferredSize
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(55.0), // Altura da área de busca + padding
        child: Container(
           decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: filterButtonBorder, width: 1.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 11.0), // Padding ajustado
            child: Row(
              children: [
                Expanded(
                  child: SearchInput(
                    onChanged: (value) {
                      filteredCatalogStore.searchQuery = value ?? '';
                    },
                    placeholder: 'Buscar',
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 56,
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      side: const BorderSide(color: filterButtonBorder),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Observer(
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar, // Use o AppBar que acabamos de criar
          body: Column(
            children: [
              const MobileCategoryList(),
              Expanded(child: ProductGrid(items: filteredCatalogStore.currentItems, expand: true,)),
            ],
          ),
        );
      },
    );
  }
}