import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../navigation/navigation_cubit.dart';

final class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Phase 1: basic splash, auto-navigate quickly.
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      context.read<NavigationCubit>().goToPokemonList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash'),
      ),
    );
  }
}