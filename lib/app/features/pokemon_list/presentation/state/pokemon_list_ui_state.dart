import 'package:equatable/equatable.dart';

import '../../../../../core/presentation/entity/pokemon_ui_entity.dart';
import '../../../../../core/presentation/state/screen_view_state.dart';

final class PokemonListUIState extends Equatable {
  const PokemonListUIState({
    required this.viewState,
    required this.items,
    required this.totalCount,
    required this.isLoadingMore,
    required this.loadMoreErrorMessage,
  });

  factory PokemonListUIState.initial() => const PokemonListUIState(
    viewState: LoadingState(),
    items: [],
    totalCount: 0,
    isLoadingMore: false,
    loadMoreErrorMessage: null,
  );

  final ScreenViewState viewState;

  final List<PokemonUIEntity> items;
  final int totalCount;
  final bool isLoadingMore;
  final String? loadMoreErrorMessage;

  bool get hasMore => items.length < totalCount;

  PokemonListUIState copyWith({
    ScreenViewState? viewState,
    List<PokemonUIEntity>? items,
    int? totalCount,
    bool? isLoadingMore,
    String? loadMoreErrorMessage,
  }) {
    return PokemonListUIState(
      viewState: viewState ?? this.viewState,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreErrorMessage: loadMoreErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    viewState,
    items,
    totalCount,
    isLoadingMore,
    loadMoreErrorMessage,
  ];
}