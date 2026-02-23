import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/entity/pokemon_detail_ui_entity.dart';
import '../../../../core/presentation/state/screen_view_state.dart';
import '../../../di/service_locator.dart';
import '../../../navigation/navigation_cubit.dart';
import 'cubit/pokemon_detail_cubit.dart';
import 'state/pokemon_detail_ui_state.dart';

final class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key, required this.pokemonId});

  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokemonDetailCubit>(
      create: (_) =>
      serviceLocator<PokemonDetailCubit>()..load(pokemonId: pokemonId),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.read<NavigationCubit>().backToPokemonList(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Detail'),
        ),
        body: BlocBuilder<PokemonDetailCubit, PokemonDetailUIState>(
          builder: (context, state) {
            return switch (state.viewState) {
              LoadingState() => const Center(child: CircularProgressIndicator()),
              ErrorState(error: final error) => _ErrorView(
                message: error.message,
                onRetry: () => context
                    .read<PokemonDetailCubit>()
                    .load(pokemonId: pokemonId),
              ),
              SuccessState() => _SuccessDetail(detail: state.data),
            };
          },
        ),
      ),
    );
  }
}

final class _SuccessDetail extends StatelessWidget {
  const _SuccessDetail({required this.detail});

  final PokemonDetailUIEntity? detail;

  @override
  Widget build(BuildContext context) {
    final d = detail;
    if (d == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Center(
          child: SizedBox(
            height: 240,
            child: Image.network(
              d.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            d.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _MetricsRow(heightMeters: d.heightMeters, weightKg: d.weightKg),
        const SizedBox(height: 16),
        _TypesChips(types: d.types),
        const SizedBox(height: 16),
        Text(
          'Stats',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ...d.stats.map((s) => _StatRow(name: s.name, value: s.baseStat)),
      ],
    );
  }
}

final class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.heightMeters, required this.weightKg});

  final double heightMeters;
  final double weightKg;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;

    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            label: 'Height',
            value: '${heightMeters.toStringAsFixed(2)} m',
            textStyle: textStyle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricTile(
            label: 'Weight',
            value: '${weightKg.toStringAsFixed(1)} kg',
            textStyle: textStyle,
          ),
        ),
      ],
    );
  }
}

final class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.textStyle,
  });

  final String label;
  final String value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(
              value,
              style: textStyle?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

final class _TypesChips extends StatelessWidget {
  const _TypesChips({required this.types});

  final List<PokemonTypeUIEntity> types;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types
          .map((t) => Chip(label: Text(_cap(t.name))))
          .toList(growable: false),
    );
  }

  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

final class _StatRow extends StatelessWidget {
  const _StatRow({required this.name, required this.value});

  final String name;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(_cap(name))),
          Expanded(
            flex: 2,
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

final class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

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