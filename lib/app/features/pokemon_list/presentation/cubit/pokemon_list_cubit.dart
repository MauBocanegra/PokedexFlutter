import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/domain/usecase/get_pokemon_list_use_case.dart';
import '../../../../../core/presentation/state/screen_view_state.dart';
import '../state/pokemon_list_ui_state.dart';

final class PokemonListCubit extends Cubit<PokemonListUIState> {
  PokemonListCubit({required GetPokemonListUseCase getPokemonListUseCase})
      : _getPokemonListUseCase = getPokemonListUseCase,
        super(PokemonListUIState.initial());

  final GetPokemonListUseCase _getPokemonListUseCase;

  static const int _pageSize = 20;

  int _offset = 0;
  bool _requestInFlight = false;

  Future<void> loadInitial() async {
    _offset = 0;
    _requestInFlight = true;

    emit(PokemonListUIState.initial());

    final result = await _getPokemonListUseCase(limit: _pageSize, offset: _offset);

    result.fold(
          (error) {
        _requestInFlight = false;
        emit(state.copyWith(viewState: ErrorState(error: error)));
      },
          (data) {
        _requestInFlight = false;
        _offset = data.items.length; // next offset
        emit(
          state.copyWith(
            viewState: const SuccessState(),
            items: data.items,
            totalCount: data.totalCount,
            isLoadingMore: false,
            loadMoreErrorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    // Guard conditions
    if (_requestInFlight) return;
    if (state.viewState is! SuccessState) return;
    if (!state.hasMore) return;

    _requestInFlight = true;
    emit(state.copyWith(isLoadingMore: true, loadMoreErrorMessage: null));

    final result = await _getPokemonListUseCase(limit: _pageSize, offset: _offset);

    result.fold(
          (error) {
        _requestInFlight = false;
        emit(
          state.copyWith(
            isLoadingMore: false,
            loadMoreErrorMessage: error.message,
          ),
        );
      },
          (data) {
        _requestInFlight = false;

        final combined = List.of(state.items)..addAll(data.items);
        _offset = combined.length;

        emit(
          state.copyWith(
            isLoadingMore: false,
            items: combined,
            totalCount: data.totalCount, // stable, but keep updated
            loadMoreErrorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> retryLoadMore() => loadMore();
}