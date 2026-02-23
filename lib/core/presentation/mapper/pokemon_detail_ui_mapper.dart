import '../../domain/model/pokemon_detail.dart';
import '../entity/pokemon_detail_ui_entity.dart';

final class PokemonDetailUIMapper {
  const PokemonDetailUIMapper();

  PokemonDetailUIEntity map(PokemonDetail detail) {
    return PokemonDetailUIEntity(
      id: detail.id,
      name: _capitalizeFirst(detail.name),
      imageUrl: _imageUrlFor(detail.id),
      // Convert: decimeters -> meters, hectograms -> kg
      heightMeters: detail.heightDecimeters / 10.0,
      weightKg: detail.weightHectograms / 10.0,
      stats: detail.stats
          .map(
            (s) => PokemonStatUIEntity(
          name: s.name,
          baseStat: s.baseStat,
        ),
      )
          .toList(growable: false),
      types: detail.types
          .map(
            (t) => PokemonTypeUIEntity(
          name: t.name,
          slot: t.slot,
        ),
      )
          .toList(growable: false),
    );
  }

  String _imageUrlFor(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png';
  }

  String _capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return '${input[0].toUpperCase()}${input.substring(1)}';
  }
}