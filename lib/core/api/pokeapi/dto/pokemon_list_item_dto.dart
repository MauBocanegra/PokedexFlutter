final class PokemonListItemDto {
  const PokemonListItemDto({
    required this.name,
    required this.url,
    required this.id,
  });

  final String name;
  final String url;
  final int id;

  factory PokemonListItemDto.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final url = json['url'];
    if (name is! String || url is! String) {
      throw const FormatException('Invalid pokemon list item');
    }

    return PokemonListItemDto(
      name: name,
      url: url,
      id: _extractIdFromUrl(url),
    );
  }

  static int _extractIdFromUrl(String url) {
    // Expected: https://pokeapi.co/api/v2/pokemon/6/
    final trimmed = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    final lastSlash = trimmed.lastIndexOf('/');
    if (lastSlash < 0 || lastSlash == trimmed.length - 1) {
      throw const FormatException('Pokemon url does not contain an id');
    }

    final idStr = trimmed.substring(lastSlash + 1);
    final id = int.tryParse(idStr);
    if (id == null || id <= 0) {
      throw const FormatException('Pokemon id in url is invalid');
    }
    return id;
  }
}