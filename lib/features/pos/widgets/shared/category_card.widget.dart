import 'package:flutter/material.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

class CategoryCard extends StatefulWidget {
  final Widget? leading;
  final String text;
  final String subtext;
  final Color? backgroundColor;
  final Color? textColor;
  final bool mobile;
  final bool isSelected;
  final DecorationImage? backgroundImage;

  const CategoryCard({
    super.key,
    this.leading,
    required this.text,
    required this.subtext,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.mobile = false,
    this.isSelected = false,
    this.backgroundImage,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = widget.mobile ? 132.0 : 152.0;
    final double cardHeight = widget.mobile ? 48.0 : 62.0;

    final EdgeInsets cardPadding = widget.mobile
        ? const EdgeInsets.all(6.0)
        : const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0);

    final double verticalTextGap = widget.mobile ? 4.0 : 6.0;

    final TextStyle? baseTitleStyle = widget.mobile
        ? Theme.of(context).textTheme.labelLarge
        : Theme.of(context).textTheme.titleSmall;

    final TextStyle? titleStyle = baseTitleStyle?.copyWith(
      color: widget.textColor,
      fontWeight: FontWeight.w600,
    );

    final TextStyle? baseSubtextStyle = widget.mobile
        ? Theme.of(context).textTheme.labelMedium
        : Theme.of(context).textTheme.bodySmall;

    final TextStyle? subtextStyle = baseSubtextStyle?.copyWith(
      color: widget.textColor,
      fontWeight: widget.mobile ? FontWeight.w400 : null,
    );

    final border = widget.isSelected
        ? Border.all(
            color: Colors.green,
            width: 2.0,
          )
        : Border.all(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            width: _isHovered ? 2.0 : 1.0,
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          image: widget.backgroundImage != null
              ? DecorationImage(
                  image: widget.backgroundImage!.image,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withAlpha(102),
                    BlendMode.darken,
                  ),
                )
              : null,
          border: border,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: 10.0),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: titleStyle,
                  ),
                  SizedBox(height: verticalTextGap),
                  Text(
                    widget.subtext,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: subtextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
