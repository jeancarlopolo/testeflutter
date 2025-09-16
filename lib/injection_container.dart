// coverage:ignore-start

// service locator
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/catalog/stores/catalog.store.dart';
import 'package:teste_flutter/features/pos/stores/expand.store.dart';
import 'package:teste_flutter/features/pos/stores/filtered_catalog.store.dart';

final sl = GetIt.I;

void slStores() {
  sl.registerLazySingleton<CatalogStore>(() => CatalogStore());
  sl.registerLazySingleton<FilteredCatalogStore>(
      () => FilteredCatalogStore(sl<CatalogStore>()));
  sl.registerLazySingleton<ExpandStore>(() => ExpandStore());
}

void init() {
  slStores();
}
