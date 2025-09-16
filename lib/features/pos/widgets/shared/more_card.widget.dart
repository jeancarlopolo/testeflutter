import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';
import 'package:teste_flutter/features/pos/stores/expand.store.dart';

class MoreCard extends StatefulWidget {
  final VoidCallback? onPressed; 
  
  const MoreCard({
    super.key,
    this.onPressed,
  });

  @override
  State<MoreCard> createState() => _MoreCardState();
}

class _MoreCardState extends State<MoreCard> {
  late final ExpandStore expandStore;

  @override
  void initState() {
    super.initState();
    expandStore = GetIt.I<ExpandStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final IconData iconData = expandStore.isExpanded ? Icons.remove : Icons.add;
        final String label = expandStore.isExpanded ? 'menos' : 'mais';
        final double height = expandStore.isExpanded ? 60.0 : 62.0;
        final textStyle = context.textTheme.labelLarge;
        
        return GestureDetector(
          onTap: () {
            expandStore.toggleExpand();
            widget.onPressed?.call();
          },
          child: SizedBox(
            width: 152,
            height: height,
            child: Container(
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
          ),
        );
      },
    );
  }
}