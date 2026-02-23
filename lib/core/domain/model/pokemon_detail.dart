import 'pokemon_stat.dart';
import 'pokemon_type.dart';

final class PokemonDetail {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.heightDecimeters,
    required this.weightHectograms,
    required this.stats,
    required this.types,
  });

  final int id;
  final String name;

  final int heightDecimeters;
  final int weightHectograms;

  final List<PokemonStat> stats;
  final List<PokemonType> types;
}