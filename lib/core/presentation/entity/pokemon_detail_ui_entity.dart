final class PokemonDetailUIEntity {
  const PokemonDetailUIEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.heightMeters,
    required this.weightKg,
    required this.stats,
    required this.types,
  });

  final int id;
  final String name;
  final String imageUrl;

  /// Already converted from PokeAPI units.
  final double heightMeters;
  final double weightKg;

  final List<PokemonStatUIEntity> stats;
  final List<PokemonTypeUIEntity> types;
}

final class PokemonStatUIEntity {
  const PokemonStatUIEntity({
    required this.name,
    required this.baseStat,
  });

  final String name;
  final int baseStat;
}

final class PokemonTypeUIEntity {
  const PokemonTypeUIEntity({
    required this.name,
    required this.slot,
  });

  final String name;
  final int slot;
}