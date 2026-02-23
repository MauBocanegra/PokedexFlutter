final class PokemonTypeDto {
  const PokemonTypeDto({
    required this.slot,
    required this.name,
  });

  final int slot;
  final String name;

  factory PokemonTypeDto.fromJson(Map<String, dynamic> json) {
    final slot = json['slot'];
    final typeJson = json['type'];

    if (typeJson is! Map<String, dynamic>) {
      throw const FormatException('Invalid "type" field in types item');
    }

    final name = typeJson['name'];
    if (name is! String) {
      throw const FormatException('Invalid "type.name" field in types item');
    }

    return PokemonTypeDto(
      slot: _asInt(slot),
      name: name,
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw const FormatException('Invalid int field in types item');
  }
}