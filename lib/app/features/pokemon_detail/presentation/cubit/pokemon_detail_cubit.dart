import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/domain/usecase/get_pokemon_detail_use_case.dart';
import '../../../../../core/presentation/state/screen_view_state.dart';
import '../state/pokemon_detail_ui_state.dart';

final class PokemonDetailCubit extends Cubit<PokemonDetailUIState> {
  PokemonDetailCubit({
    required GetPokemonDetailUseCase getPokemonDetailUseCase,
  })  : _getPokemonDetailUseCase = getPokemonDetailUseCase,
        super(PokemonDetailUIState.initial());

  final GetPokemonDetailUseCase _getPokemonDetailUseCase;

  Future<void> load({required int pokemonId}) async {
    emit(state.copyWith(viewState: const LoadingState()));

    final result = await _getPokemonDetailUseCase(pokemonId: pokemonId);

    result.fold(
          (error) => emit(state.copyWith(viewState: ErrorState(error: error))),
          (data) => emit(
        state.copyWith(
          viewState: const SuccessState(),
          data: data,
        ),
      ),
    );
  }
}