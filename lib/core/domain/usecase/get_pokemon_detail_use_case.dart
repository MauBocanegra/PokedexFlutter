import 'package:either_dart/either.dart';

import '../../presentation/entity/pokemon_detail_ui_entity.dart';
import '../../presentation/error/ui_error.dart';
import '../../presentation/mapper/pokemon_detail_ui_mapper.dart';
import '../../presentation/mapper/repository_error_ui_mapper.dart';
import '../repository/pokemon_repository.dart';

final class GetPokemonDetailUseCase {
  GetPokemonDetailUseCase({
    required PokemonRepository repository,
    required PokemonDetailUIMapper pokemonDetailUIMapper,
    required RepositoryErrorUIMapper errorUiMapper,
  })  : _repository = repository,
        _pokemonDetailUIMapper = pokemonDetailUIMapper,
        _errorUiMapper = errorUiMapper;

  final PokemonRepository _repository;
  final PokemonDetailUIMapper _pokemonDetailUIMapper;
  final RepositoryErrorUIMapper _errorUiMapper;

  Future<Either<UiError, PokemonDetailUIEntity>> call({
    required int pokemonId,
  }) async {
    final result = await _repository.getPokemonDetail(pokemonId: pokemonId);

    return result.fold(
          (error) => Left(_errorUiMapper.map(error)),
          (detail) => Right(_pokemonDetailUIMapper.map(detail)),
    );
  }
}