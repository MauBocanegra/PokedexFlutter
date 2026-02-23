import 'package:flutter/material.dart';

import 'app/di/service_locator.dart';
import 'app/pokedex_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const PokedexApp());
}