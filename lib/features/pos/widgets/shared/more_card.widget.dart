import 'package:flutter/material.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

class MoreCard extends StatefulWidget {
  final bool initiallyPressed;
  final VoidCallback? showMore;
  final VoidCallback? showLess;

  const MoreCard({
    super.key,
    this.initiallyPressed = false,
    this.showMore,
    this.showLess,
  });

  @override
  State<MoreCard> createState() => _MoreCardState();
}

class _MoreCardState extends State<MoreCard> {
  late bool _isPressed;

  @override
  void initState() {
    super.initState();
    _isPressed = widget.initiallyPressed;
  }

  void _handleTap() {
    setState(() {
      _isPressed = !_isPressed;
    });
    if (!_isPressed) {
      widget.showMore?.call();
    } else {
      widget.showLess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconData iconData = _isPressed ? Icons.remove : Icons.add;
    final String label = _isPressed ? 'menos' : 'mais';
    final double height = _isPressed ? 60.0 : 62.0;

    final pressedTextStyle = context.textTheme.labelLarge;

    final unpressedTextStyle = context.textTheme.labelLarge;

    return GestureDetector(
      onTap: _handleTap,
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
                style: _isPressed ? pressedTextStyle : unpressedTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
