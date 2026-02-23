import 'package:equatable/equatable.dart';

sealed class NavigationState extends Equatable {
  const NavigationState();
}

final class SplashNavState extends NavigationState {
  const SplashNavState();

  @override
  List<Object?> get props => const [];
}

final class PokemonListNavState extends NavigationState {
  const PokemonListNavState();

  @override
  List<Object?> get props => const [];
}

final class PokemonDetailNavState extends NavigationState {
  const PokemonDetailNavState({required this.pokemonId});

  final int pokemonId;

  @override
  List<Object?> get props => [pokemonId];
}