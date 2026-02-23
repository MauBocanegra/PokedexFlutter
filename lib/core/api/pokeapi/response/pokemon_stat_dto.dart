final class PokemonStatDto {
  const PokemonStatDto({
    required this.baseStat,
    required this.effort,
    required this.name,
  });

  final int baseStat;
  final int effort;
  final String name;

  factory PokemonStatDto.fromJson(Map<String, dynamic> json) {
    final baseStat = json['base_stat'];
    final effort = json['effort'];
    final statJson = json['stat'];

    if (statJson is! Map<String, dynamic>) {
      throw const FormatException('Invalid "stat" field in stats item');
    }

    final name = statJson['name'];
    if (name is! String) {
      throw const FormatException('Invalid "stat.name" field in stats item');
    }

    return PokemonStatDto(
      baseStat: _asInt(baseStat),
      effort: _asInt(effort),
      name: name,
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw const FormatException('Invalid int field in stats item');
  }
}