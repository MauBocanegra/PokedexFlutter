import '../../../../network/remote_response.dart';
import '../../client/pokeapi_http_client.dart';
import '../../dto/pokemon_detail_response_dto.dart';
import '../../response/pokemon_list_response_dto.dart';
import '../pokemon_remote_data_source.dart';

final class PokemonHttpRemoteDataSource implements PokemonRemoteDataSource {
  PokemonHttpRemoteDataSource({required PokeApiHttpClient client})
      : _client = client;

  final PokeApiHttpClient _client;

  @override
  Future<PokeApiRemoteResponse<PokemonListResponseDto>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final jsonResult = await _client.getJson(
      '/pokemon/',
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
      },
    );

    return switch (jsonResult) {
      PokeApiSuccess<Map<String, dynamic>>(data: final json) => _parseList(json),
      PokeApiFailure<Map<String, dynamic>>(error: final e, stackTrace: final st) =>
          PokeApiFailure(error: e, stackTrace: st),
    };
  }

  @override
  Future<PokeApiRemoteResponse<PokemonDetailResponseDto>> getPokemonDetail({
    required int pokemonId,
  }) async {
    final jsonResult = await _client.getJson('/pokemon/$pokemonId/');

    return switch (jsonResult) {
      PokeApiSuccess<Map<String, dynamic>>(data: final json) =>
          _parseDetail(json),
      PokeApiFailure<Map<String, dynamic>>(error: final e, stackTrace: final st) =>
          PokeApiFailure(error: e, stackTrace: st),
    };
  }

  PokeApiRemoteResponse<PokemonListResponseDto> _parseList(
      Map<String, dynamic> json,
      ) {
    try {
      return PokeApiSuccess(PokemonListResponseDto.fromJson(json));
    } on FormatException catch (e, st) {
      return PokeApiFailure(
        error: PokeApiParsingError(message: e.message),
        stackTrace: st,
      );
    } catch (e, st) {
      return PokeApiFailure(
        error: PokeApiUnknownError(message: e.toString()),
        stackTrace: st,
      );
    }
  }

  PokeApiRemoteResponse<PokemonDetailResponseDto> _parseDetail(
      Map<String, dynamic> json,
      ) {
    try {
      return PokeApiSuccess(PokemonDetailResponseDto.fromJson(json));
    } on FormatException catch (e, st) {
      return PokeApiFailure(
        error: PokeApiParsingError(message: e.message),
        stackTrace: st,
      );
    } catch (e, st) {
      return PokeApiFailure(
        error: PokeApiUnknownError(message: e.toString()),
        stackTrace: st,
      );
    }
  }
}