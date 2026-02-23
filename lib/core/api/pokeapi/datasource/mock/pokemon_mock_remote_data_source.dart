import 'package:pokedex_pl/core/api/pokeapi/datasource/mock/pokemon_mock_json.dart';

import '../../../../network/remote_response.dart';
import '../../dto/pokemon_detail_response_dto.dart';
import '../../response/pokemon_list_response_dto.dart';
import '../pokemon_remote_data_source.dart';

final class MockPokemonRemoteDataSource implements PokemonRemoteDataSource {
  const MockPokemonRemoteDataSource();

  @override
  Future<PokeApiRemoteResponse<PokemonListResponseDto>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    try {
      final json = PokemonMockJson.pokemonListPage1();
      final dto = PokemonListResponseDto.fromJson(json);
      return PokeApiSuccess(dto);
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

  @override
  Future<PokeApiRemoteResponse<PokemonDetailResponseDto>> getPokemonDetail({
    required int pokemonId,
  }) async {
    try {
      final json = PokemonMockJson.pokemonDetail(id: pokemonId);
      final dto = PokemonDetailResponseDto.fromJson(json);
      return PokeApiSuccess(dto);
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