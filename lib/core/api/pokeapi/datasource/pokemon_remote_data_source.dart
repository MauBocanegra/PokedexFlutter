import '../../../network/remote_response.dart';
import '../dto/pokemon_detail_response_dto.dart';
import '../response/pokemon_list_response_dto.dart';

abstract interface class PokemonRemoteDataSource {
  Future<PokeApiRemoteResponse<PokemonListResponseDto>> getPokemonList({
    required int limit,
    required int offset,
  });

  Future<PokeApiRemoteResponse<PokemonDetailResponseDto>> getPokemonDetail({
    required int pokemonId,
  });
}