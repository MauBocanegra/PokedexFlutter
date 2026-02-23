import '../../domain/model/pokemon.dart';
import '../entity/pokemon_ui_entity.dart';

final class PokemonUIMapper {
  const PokemonUIMapper();

  PokemonUIEntity map(Pokemon pokemon) {
    return PokemonUIEntity(
      id: pokemon.id,
      name: _capitalizeFirst(pokemon.name),
      imageUrl: _imageUrlFor(pokemon.id),
    );
  }

  String _imageUrlFor(int id) {

    //return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png';
  }

  String _capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    final first = input[0].toUpperCase();
    final rest = input.substring(1);
    return '$first$rest';
  }
}