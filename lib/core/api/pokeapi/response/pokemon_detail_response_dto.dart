final class PokemonDetailResponseDto {
  const PokemonDetailResponseDto({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory PokemonDetailResponseDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];

    if (name is! String) {
      throw const FormatException('Invalid "name" field in detail response');
    }

    return PokemonDetailResponseDto(
      id: _asInt(id),
      name: name,
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw const FormatException('Invalid int field in detail response');
  }
}