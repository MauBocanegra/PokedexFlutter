import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_state.dart';

final class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const SplashNavState());

  void showSplash() => emit(const SplashNavState());

  void goToPokemonList() => emit(const PokemonListNavState());

  void goToPokemonDetail({required int pokemonId}) =>
      emit(PokemonDetailNavState(pokemonId: pokemonId));

  void backToPokemonList() => emit(const PokemonListNavState());
}