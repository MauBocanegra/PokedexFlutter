import 'package:either_dart/either.dart';

import '../../presentation/entity/pokemon_list_ui_entity.dart';
import '../../presentation/error/ui_error.dart';
import '../../presentation/mapper/pokemon_ui_mapper.dart';
import '../../presentation/mapper/repository_error_ui_mapper.dart';
import '../repository/pokemon_repository.dart';

final class GetPokemonListUseCase {
  GetPokemonListUseCase({
    required PokemonRepository repository,
    required PokemonUIMapper pokemonUiMapper,
    required RepositoryErrorUIMapper errorUiMapper,
  })  : _repository = repository,
        _pokemonUiMapper = pokemonUiMapper,
        _errorUiMapper = errorUiMapper;

  final PokemonRepository _repository;
  final PokemonUIMapper _pokemonUiMapper;
  final RepositoryErrorUIMapper _errorUiMapper;

  Future<Either<UiError, PokemonListUIEntity>> call({
    required int limit,
    required int offset,
  }) async {
    final result = await _repository.getPokemonList(limit: limit, offset: offset);

    return result.fold(
          (error) => Left(_errorUiMapper.map(error)),
          (page) => Right(
        PokemonListUIEntity(
          totalCount: page.totalCount,
          items: page.items.map(_pokemonUiMapper.map).toList(growable: false),
        ),
      ),
    );
  }
}