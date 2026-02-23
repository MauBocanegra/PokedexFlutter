final class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String pokemonList = '/pokemon';
  static const String pokemonDetail = '/pokemon/:id';

  static String detailFor(int id) => '/pokemon/$id';
}