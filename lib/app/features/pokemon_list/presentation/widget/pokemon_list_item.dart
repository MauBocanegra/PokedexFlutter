import 'package:flutter/material.dart';

import '../../../../../core/presentation/entity/pokemon_ui_entity.dart';

final class PokemonListItem extends StatelessWidget {
  const PokemonListItem({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  final PokemonUIEntity pokemon;
  final VoidCallback onTap;

  static const double _parentHeight = 200;
  static const double _cardHeight = 120;

  static const double _outerPadding = 8;
  static const double _cardElevation = 8;

  static const double _imageSideInset = 8;

  @override
  Widget build(BuildContext context) {
    final isEven = pokemon.id.isEven;

    return SizedBox(
      height: _parentHeight,
      child: Padding(
        padding: const EdgeInsets.all(_outerPadding),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageContainerWidth = constraints.maxWidth * (6 / 10);
                final imageContainerHeight = constraints.maxHeight;

                // When image is on the left, push text to the right; when image is on the right, push text to the left.
                final textPadding = isEven
                    ? const EdgeInsets.fromLTRB(8, 8, 24, 8) // image left => extra padding on right
                    : const EdgeInsets.fromLTRB(24, 8, 8, 8); // image right => extra padding on left

                final textAlignment =
                isEven ? Alignment.centerRight : Alignment.centerLeft;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Bottom card
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Material(
                        color: Colors.white,
                        elevation: _cardElevation,
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: _cardHeight,
                          width: double.infinity,
                          child: Padding(
                            padding: textPadding,
                            child: Align(
                              alignment: textAlignment,
                              child: Text(
                                pokemon.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 26,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign:
                                isEven ? TextAlign.right : TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Image: odd -> right, even -> left
                    Positioned(
                      left: isEven ? _imageSideInset : null,
                      right: isEven ? null : _imageSideInset,
                      bottom: 0,
                      child: SizedBox(
                        width: imageContainerWidth,
                        height: _parentHeight,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: imageContainerWidth - 30,
                            height: imageContainerHeight,
                            child: Image.network(
                              pokemon.imageUrl,
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                              errorBuilder: (_, __, ___) =>
                              const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}