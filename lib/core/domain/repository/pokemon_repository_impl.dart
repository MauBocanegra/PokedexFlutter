import 'package:either_dart/either.dart';

import '../../api/pokeapi/datasource/pokemon_remote_data_source.dart';
import '../../api/pokeapi/dto/pokemon_detail_response_dto.dart';
import '../../api/pokeapi/response/pokemon_list_response_dto.dart';
import '../../network/remote_response.dart';
import '../error/repository_error.dart';
import '../model/pokemon.dart';
import '../model/pokemon_detail.dart';
import '../model/pokemon_list_page.dart';
import '../model/pokemon_stat.dart';
import '../model/pokemon_type.dart';
import 'pokemon_repository.dart';

final class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl({
    required PokemonRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final PokemonRemoteDataSource _remoteDataSource;

  @override
  Future<Either<RepositoryError, PokemonListPage>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final response = await _remoteDataSource.getPokemonList(
      limit: limit,
      offset: offset,
    );

    return switch (response) {
      PokeApiSuccess<PokemonListResponseDto>(data: final dto) =>
          Right(_mapListDtoToDomain(dto)),
      PokeApiFailure<PokemonListResponseDto>(error: final error, stackTrace: _) =>
          Left(_mapRemoteError(error)),
    };
  }

  @override
  Future<Either<RepositoryError, PokemonDetail>> getPokemonDetail({
    required int pokemonId,
  }) async {
    final response = await _remoteDataSource.getPokemonDetail(
      pokemonId: pokemonId,
    );

    return switch (response) {
      PokeApiSuccess<PokemonDetailResponseDto>(data: final dto) =>
          Right(_mapDetailDtoToDomain(dto)),
      PokeApiFailure<PokemonDetailResponseDto>(error: final error, stackTrace: _) =>
          Left(_mapRemoteError(error)),
    };
  }

  RepositoryError _mapRemoteError(PokeApiRemoteError error) {
    return switch (error) {
      PokeApiNetworkError(message: final msg) =>
          RepositoryNetworkError(message: msg),
      PokeApiParsingError(message: final msg) =>
          RepositoryParsingError(message: msg),
      PokeApiUnknownError(message: final msg) =>
          RepositoryUnknownError(message: msg),
    };
  }

  PokemonListPage _mapListDtoToDomain(PokemonListResponseDto dto) {
    return PokemonListPage(
      totalCount: dto.count,
      items: dto.results
          .map(
            (e) => Pokemon(
          id: e.id,
          name: e.name,
        ),
      )
          .toList(growable: false),
    );
  }

  PokemonDetail _mapDetailDtoToDomain(PokemonDetailResponseDto dto) {
    return PokemonDetail(
      id: dto.id,
      name: dto.name,
      heightDecimeters: dto.height,
      weightHectograms: dto.weight,
      stats: dto.stats
          .map(
            (s) => PokemonStat(
          name: s.name,
          baseStat: s.baseStat,
          effort: s.effort,
        ),
      )
          .toList(growable: false),
      types: dto.types
          .map(
            (t) => PokemonType(
          slot: t.slot,
          name: t.name,
        ),
      )
          .toList(growable: false),
    );
  }
}