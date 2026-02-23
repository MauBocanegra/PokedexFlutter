import '../response/pokemon_stat_dto.dart';
import '../response/pokemon_type_dto.dart';

final class PokemonDetailResponseDto {
  const PokemonDetailResponseDto({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.stats,
    required this.types,
  });

  final int id;
  final String name;

  /// PokeAPI units: decimeters
  final int height;

  /// PokeAPI units: hectograms
  final int weight;

  final List<PokemonStatDto> stats;
  final List<PokemonTypeDto> types;

  factory PokemonDetailResponseDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final height = json['height'];
    final weight = json['weight'];

    final statsJson = json['stats'];
    final typesJson = json['types'];

    if (name is! String) {
      throw const FormatException('Invalid "name" field in detail response');
    }
    if (statsJson is! List) {
      throw const FormatException('Invalid "stats" field in detail response');
    }
    if (typesJson is! List) {
      throw const FormatException('Invalid "types" field in detail response');
    }

    final parsedStats = statsJson
        .whereType<Map<String, dynamic>>()
        .map(PokemonStatDto.fromJson)
        .toList(growable: false);

    final parsedTypes = typesJson
        .whereType<Map<String, dynamic>>()
        .map(PokemonTypeDto.fromJson)
        .toList(growable: false);

    return PokemonDetailResponseDto(
      id: _asInt(id),
      name: name,
      height: _asInt(height),
      weight: _asInt(weight),
      stats: parsedStats,
      types: parsedTypes,
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw const FormatException('Invalid int field in detail response');
  }
}