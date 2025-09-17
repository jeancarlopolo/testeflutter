import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';
import 'package:teste_flutter/features/pos/stores/expand.store.dart';

class MoreCard extends StatelessWidget {
  final VoidCallback? onPressed;
  final ExpandStore store;
  final double height;

  const MoreCard({
    super.key,
    this.onPressed,
    required this.store,
    this.height = 74.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Observer(
        builder: (context) {
          final IconData iconData = store.isExpanded ? Icons.remove : Icons.add;
          final String label = store.isExpanded ? 'Ver menos' : 'Ver mais';
          final textStyle = context.textTheme.labelLarge;
          const double cardWidth = 152.0;

          return GestureDetector(
            onTap: () {
              store.toggleExpand();
              onPressed?.call();
            },
            child: Container(
              width: cardWidth,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                border: Border.all(color: Colors.black.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(iconData, size: 24, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: textStyle,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
