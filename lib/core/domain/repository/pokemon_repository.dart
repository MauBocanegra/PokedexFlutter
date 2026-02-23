import 'package:either_dart/either.dart';

import '../error/repository_error.dart';
import '../model/pokemon_detail.dart';
import '../model/pokemon_list_page.dart';

abstract interface class PokemonRepository {
  Future<Either<RepositoryError, PokemonListPage>> getPokemonList({
    required int limit,
    required int offset,
  });

  Future<Either<RepositoryError, PokemonDetail>> getPokemonDetail({
    required int pokemonId,
  });
}