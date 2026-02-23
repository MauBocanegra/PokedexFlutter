import 'package:equatable/equatable.dart';

import '../../../../../core/presentation/entity/pokemon_detail_ui_entity.dart';
import '../../../../../core/presentation/state/screen_view_state.dart';

final class PokemonDetailUIState extends Equatable {
  const PokemonDetailUIState({
    required this.viewState,
    required this.data,
  });

  factory PokemonDetailUIState.initial() => const PokemonDetailUIState(
    viewState: LoadingState(),
    data: null,
  );

  final ScreenViewState viewState;
  final PokemonDetailUIEntity? data;

  PokemonDetailUIState copyWith({
    ScreenViewState? viewState,
    PokemonDetailUIEntity? data,
  }) {
    return PokemonDetailUIState(
      viewState: viewState ?? this.viewState,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [viewState, data];
}