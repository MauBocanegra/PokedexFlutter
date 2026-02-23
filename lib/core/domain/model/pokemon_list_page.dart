import 'pokemon.dart';

final class PokemonListPage {
  const PokemonListPage({
    required this.totalCount,
    required this.items,
  });

  final int totalCount;
  final List<Pokemon> items;
}