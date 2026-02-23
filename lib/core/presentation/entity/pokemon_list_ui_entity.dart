import 'pokemon_ui_entity.dart';

final class PokemonListUIEntity {
  const PokemonListUIEntity({
    required this.totalCount,
    required this.items,
  });

  final int totalCount;
  final List<PokemonUIEntity> items;
}