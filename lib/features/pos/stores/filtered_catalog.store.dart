import 'package:mobx/mobx.dart';
import 'package:teste_flutter/features/catalog/entities/category.entity.dart';
import 'package:teste_flutter/features/catalog/entities/item_categoria.entity.dart';
import 'package:teste_flutter/features/catalog/stores/catalog.store.dart';
import 'package:teste_flutter/utils/extension_methos/extension_methods.dart';
part 'filtered_catalog.store.g.dart';

class FilteredCatalogStore = FilteredCatalogStoreBase
    with _$FilteredCatalogStore;

abstract class FilteredCatalogStoreBase with Store {
  FilteredCatalogStoreBase(this.catalogStore);

  @observable
  CatalogStore catalogStore;



  @observable
  String searchQuery = '';

  @observable
  Categoria? selectedCategory;

  @computed
  List<ItemCategoria> get currentItems {
    if (selectedCategory != null) {
      return selectedCategory?.itens ?? [];
    } else if (searchQuery.isNotEmpty) {
      return filteredItems;
    } else {
      return allItems;
    }
  }

  @computed
  List<Categoria> get filteredCategories {
    if (catalogStore.categorias.isEmpty) return [];
    return filterCategories(searchQuery);
  }

  @computed
  List<ItemCategoria> get filteredItems {
    return filteredCategories
        .expand((cat) => cat.itens ?? <ItemCategoria>[])
        .toSet()
        .toList();
  }

  @computed
  List<ItemCategoria> get allItems {
    return catalogStore.categorias
        .expand((cat) => cat.itens ?? [])
        .toSet()
        .toList() as List<ItemCategoria>;
  }

  @action
  List<Categoria> filterCategories(String query) {
    if (query.isEmpty) {
      return catalogStore.categorias;
    }
    final lowerQuery = query.toSearchTerm();
    return catalogStore.categorias
        .where((cat) =>
            (cat.nome?.toSearchTerm().contains(lowerQuery) ?? false) ||
            (cat.itens?.any(
                    (item) => item.nome.toSearchTerm().contains(lowerQuery)) ??
                false))
        .toList();
  }
}
