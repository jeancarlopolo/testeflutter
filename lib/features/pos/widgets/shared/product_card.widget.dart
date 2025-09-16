import 'package:flutter/material.dart';
import 'package:teste_flutter/features/catalog/entities/cashback.entity.dart';
import 'package:teste_flutter/features/catalog/entities/dia_semana_cashback.entity.dart';
import 'package:teste_flutter/features/catalog/entities/item_categoria.entity.dart';
import 'package:teste_flutter/features/catalog/enums/status.enum.dart';
import 'package:teste_flutter/utils/extension_methos/extension_methods.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

class ItemCard extends StatelessWidget {
  final ItemCategoria item;

  const ItemCard({Key? key, required this.item}) : super(key: key);

  static const Color lightBorderColor = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color textPriceColor = Color.fromRGBO(0, 0, 0, 0.5);

  bool get _hasActiveCashback {
    // If the cashback object itself is null, there's no active cashback.
    if (item.cashback == null) {
      return false;
    }

    // Get the current day of the week (Monday = 1, Sunday = 7)
    final int today = DateTime.now().weekday;
    final Cashback cashbackRules = item.cashback!;

    // A temporary variable to hold the rules for today.
    DiaSemanaCashback? todayCashbackRule;

    // Assign the correct day's rules based on the current weekday.
    switch (today) {
      case DateTime.monday:
        todayCashbackRule = cashbackRules.segunda;
        break;
      case DateTime.tuesday:
        todayCashbackRule = cashbackRules.terca;
        break;
      case DateTime.wednesday:
        todayCashbackRule = cashbackRules.quarta;
        break;
      case DateTime.thursday:
        todayCashbackRule = cashbackRules.quinta;
        break;
      case DateTime.friday:
        todayCashbackRule = cashbackRules.sexta;
        break;
      case DateTime.saturday:
        todayCashbackRule = cashbackRules.sabado;
        break;
      case DateTime.sunday:
        todayCashbackRule = cashbackRules.domingo;
        break;
    }

    if (todayCashbackRule == null) {
      return false;
    }

    return (todayCashbackRule.ativoDelivery) ||
        (todayCashbackRule.ativoNolocal);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = item.status == StatusEnum.disponivel || item.status ==  StatusEnum.novidade;
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        width: 132,
        height: 186,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: lightBorderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoSection(),
            const SizedBox(height: 6), // Corresponds to the main gap
            ContentSection(item: item, textPriceColor: textPriceColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return SizedBox(
      width: 120,
      height: 110,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              item.fotoPrincipal ?? '',
              width: 120,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 110,
                  color: Colors.grey[200],
                  child: Icon(Icons.shopping_bag_outlined,
                      color: Colors.grey[400]),
                );
              },
            ),
          ),
          if (item.status == StatusEnum.indisponivel) _buildUnavailableTag(),

          // /* Discount */ - Shows discount percentage from the model
          if (item.statusPromocao && item.porcentagemPromocional > 0)
            _buildDiscountTag(),

          // /* Cashback */ icon
          if (_hasActiveCashback) const CashBackIcon(),

          // /* Gift */ icon - Showing if it's a promotion
          if (item.statusPromocao) const GiftIcon(),

          // /* Open product */ - The add button
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Positioned(
      right: 4,
      bottom: 5,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: lightBorderColor),
        ),
        child: const Icon(Icons.add, size: 18, color: Colors.black),
      ),
    );
  }

  Widget _buildUnavailableTag() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: const Center(
          child: Text(
            'INDISPONÍVEL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountTag() {
    return Positioned(
      left: 10,
      top: 11,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '-${item.porcentagemPromocional}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}

class ContentSection extends StatelessWidget {
  const ContentSection({
    super.key,
    required this.item,
    required this.textPriceColor,
  });

  final ItemCategoria item;
  final Color textPriceColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // /* Name */ & /* Categorie */
          Text(
            item.nome, // Use nome from the model
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const Spacer(), // Pushes the price to the bottom
          // /* Price */ - This part is conditional
          if (item.statusPromocao && item.precoPromocional > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  item.preco.format(), // Old price
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  item.precoPromocional.format(),
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            )

          // REGULAR PRICE VIEW
          else
            Text(
              item.preco.format(), // Regular price
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            )
        ],
      ),
    );
  }
}

class CashBackIcon extends StatelessWidget {
  const CashBackIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 39,
      top: 6,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.monetization_on, color: Colors.white, size: 16),
      ),
    );
  }
}

class GiftIcon extends StatelessWidget {
  const GiftIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4,
      top: 6,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.card_giftcard, color: Colors.white, size: 16),
      ),
    );
  }
}
