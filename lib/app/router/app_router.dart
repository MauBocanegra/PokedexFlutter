import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/pokemon_detail/presentation/pokemon_detail_screen.dart';
import '../features/pokemon_list/presentation/pokemon_list_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../navigation/navigation_cubit.dart';
import '../navigation/navigation_state.dart';
import 'app_route_names.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

final class AppRouter {
  AppRouter({required NavigationCubit navigationCubit})
      : _navigationCubit = navigationCubit,
        _rootNavigatorKey = GlobalKey<NavigatorState>() {
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(_navigationCubit.stream),
      redirect: (context, state) => _redirect(state),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.splash,
          name: AppRouteNames.splash,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.pokemonList,
          name: AppRouteNames.pokemonList,
          builder: (_, __) => const PokemonListScreen(),
        ),
        GoRoute(
          path: AppRoutes.pokemonDetail,
          name: AppRouteNames.pokemonDetail,
          builder: (_, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');
            if (id == null) return const PokemonListScreen();
            return PokemonDetailScreen(pokemonId: id);
          },
        ),
      ],
    );
  }

  final NavigationCubit _navigationCubit;
  final GlobalKey<NavigatorState> _rootNavigatorKey;

  late final GoRouter _router;

  GoRouter get router => _router;

  String? _redirect(GoRouterState state) {
    final target = _targetLocationFor(_navigationCubit.state);

    // Avoid redirect loops
    if (state.matchedLocation == target) return null;

    // Phase 1: NavigationCubit is the source of truth for navigation.
    return target;
  }

  String _targetLocationFor(NavigationState nav) {
    return switch (nav) {
      SplashNavState() => AppRoutes.splash,
      PokemonListNavState() => AppRoutes.pokemonList,
      PokemonDetailNavState(pokemonId: final id) => AppRoutes.detailFor(id),
    };
  }
}