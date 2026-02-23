final class PokemonMockJson {
  const PokemonMockJson._();

  static Map<String, dynamic> pokemonListPage1() {
    // Minimal shape matching PokeAPI list response.
    return <String, dynamic>{
      'count': 1281,
      'next': 'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
      'previous': null,
      'results': List<Map<String, dynamic>>.generate(20, (index) {
        final id = index + 1;
        return <String, dynamic>{
          'name': 'pokemon $id',
          'url': 'https://pokeapi.co/api/v2/pokemon/$id/',
        };
      }),
    };
  }

  static Map<String, dynamic> pokemonDetail({required int id}) {
    // Minimal shape matching PokeAPI pokemon detail response.
    return <String, dynamic>{
      'id': id,
      'name': 'pokemon $id',
    };
  }
}