import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/state/screen_view_state.dart';
import '../../../di/service_locator.dart';
import '../../../navigation/navigation_cubit.dart';
import 'cubit/pokemon_list_cubit.dart';
import 'state/pokemon_list_ui_state.dart';
import 'widget/pokemon_list_item.dart';

final class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

final class _PokemonListScreenState extends State<PokemonListScreen> {
  late final ScrollController _controller;
  late final PokemonListCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = serviceLocator<PokemonListCubit>()..loadInitial();
    _controller = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    const threshold = 300.0;
    final position = _controller.position;
    if (position.maxScrollExtent - position.pixels <= threshold) {
      _cubit.loadMore();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokemonListCubit>.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Pokemon')),
        body: BlocBuilder<PokemonListCubit, PokemonListUIState>(
          builder: (context, state) {
            return switch (state.viewState) {
              LoadingState() => const Center(child: CircularProgressIndicator()),
              ErrorState(error: final error) => _ErrorView(
                message: error.message,
                onRetry: () => _cubit.loadInitial(),
              ),
              SuccessState() => _SuccessList(
                controller: _controller,
                state: state,
              ),
            };
          },
        ),
      ),
    );
  }
}

final class _SuccessList extends StatelessWidget {
  const _SuccessList({
    required this.controller,
    required this.state,
  });

  final ScrollController controller;
  final PokemonListUIState state;

  @override
  Widget build(BuildContext context) {
    final items = state.items;

    if (items.isEmpty) {
      return const Center(child: Text('No results'));
    }

    return ListView.builder(
      controller: controller,
      itemCount: items.length + 1, // + footer
      itemBuilder: (context, index) {
        if (index < items.length) {
          final pokemon = items[index];
          return PokemonListItem(
            pokemon: pokemon,
            onTap: () => context
                .read<NavigationCubit>()
                .goToPokemonDetail(pokemonId: pokemon.id),
          );
        }

        // Footer
        if (state.isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.loadMoreErrorMessage != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.loadMoreErrorMessage!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => context.read<PokemonListCubit>().retryLoadMore(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!state.hasMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text('End of list')),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

final class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}