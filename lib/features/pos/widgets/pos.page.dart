import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/pos/widgets/desktop/desktop_catalog.page.dart';
import 'package:teste_flutter/shared/widgets/primary_button.widget.dart';

import '../../catalog/stores/catalog.store.dart';

class PosPage extends StatelessWidget {
  PosPage({super.key});

  final catalogStore = GetIt.I<CatalogStore>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 360) {
        return const DesktopCatalogPage(storeName: '[nome loja]');
      }
      return const SizedBox();
    });
  }
}
