import '../dto/pokemon_list_item_dto.dart';

final class PokemonListResponseDto {
  const PokemonListResponseDto({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItemDto> results;

  factory PokemonListResponseDto.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'];
    if (resultsJson is! List) {
      throw const FormatException('Invalid "results" field in list response');
    }

    return PokemonListResponseDto(
      count: _asInt(json['count']),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: resultsJson
          .whereType<Map<String, dynamic>>()
          .map(PokemonListItemDto.fromJson)
          .toList(growable: false),
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw const FormatException('Invalid int field in list response');
  }
}