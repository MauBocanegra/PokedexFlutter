import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../core/api/pokeapi/client/pokeapi_http_client.dart';
import '../../core/api/pokeapi/datasource/pokemon_remote_data_source.dart';
import '../../core/api/pokeapi/datasource/remote/pokemon_http_remote_data_source.dart';
import '../../core/domain/repository/pokemon_repository.dart';
import '../../core/domain/repository/pokemon_repository_impl.dart';
import '../../core/domain/usecase/get_pokemon_detail_use_case.dart';
import '../../core/domain/usecase/get_pokemon_list_use_case.dart';
import '../../core/presentation/mapper/pokemon_detail_ui_mapper.dart';
import '../../core/presentation/mapper/pokemon_ui_mapper.dart';
import '../../core/presentation/mapper/repository_error_ui_mapper.dart';
import '../features/pokemon_detail/presentation/cubit/pokemon_detail_cubit.dart';
import '../features/pokemon_list/presentation/cubit/pokemon_list_cubit.dart';
import '../navigation/navigation_cubit.dart';
import '../router/app_router.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
  
  // Navigation
  if (!serviceLocator.isRegistered<NavigationCubit>()) {
    serviceLocator.registerLazySingleton<NavigationCubit>(NavigationCubit.new);
  }

  if (!serviceLocator.isRegistered<AppRouter>()) {
    serviceLocator.registerLazySingleton<AppRouter>(
          () => AppRouter(navigationCubit: serviceLocator<NavigationCubit>()),
    );
  }
  
  // HTTP / API client
  if (!serviceLocator.isRegistered<http.Client>()) {
    serviceLocator.registerLazySingleton<http.Client>(http.Client.new);
  }

  if (!serviceLocator.isRegistered<PokeApiHttpClient>()) {
    serviceLocator.registerLazySingleton<PokeApiHttpClient>(
          () => PokeApiHttpClient(client: serviceLocator<http.Client>()),
    );
  }

  // Remote data source (REAL)
  if (!serviceLocator.isRegistered<PokemonRemoteDataSource>()) {
    serviceLocator.registerLazySingleton<PokemonRemoteDataSource>(
          () => PokemonHttpRemoteDataSource(
        client: serviceLocator<PokeApiHttpClient>(),
      ),
    );
  }

  // Repository (single global)
  if (!serviceLocator.isRegistered<PokemonRepository>()) {
    serviceLocator.registerLazySingleton<PokemonRepository>(
          () => PokemonRepositoryImpl(
        remoteDataSource: serviceLocator<PokemonRemoteDataSource>(),
      ),
    );
  }

  // Presentation mappers
  if (!serviceLocator.isRegistered<PokemonUIMapper>()) {
    serviceLocator.registerLazySingleton<PokemonUIMapper>(PokemonUIMapper.new);
  }

  if (!serviceLocator.isRegistered<RepositoryErrorUIMapper>()) {
    serviceLocator.registerLazySingleton<RepositoryErrorUIMapper>(
      RepositoryErrorUIMapper.new,
    );
  }

  if (!serviceLocator.isRegistered<PokemonDetailUIMapper>()) {
    serviceLocator.registerLazySingleton<PokemonDetailUIMapper>(
      PokemonDetailUIMapper.new,
    );
  }

  // Use cases (return UIEntities)
  if (!serviceLocator.isRegistered<GetPokemonListUseCase>()) {
    serviceLocator.registerLazySingleton<GetPokemonListUseCase>(
          () => GetPokemonListUseCase(
        repository: serviceLocator<PokemonRepository>(),
        pokemonUiMapper: serviceLocator<PokemonUIMapper>(),
        errorUiMapper: serviceLocator<RepositoryErrorUIMapper>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetPokemonDetailUseCase>()) {
    serviceLocator.registerLazySingleton<GetPokemonDetailUseCase>(
          () => GetPokemonDetailUseCase(
        repository: serviceLocator<PokemonRepository>(),
        pokemonDetailUIMapper: serviceLocator<PokemonDetailUIMapper>(),
        errorUiMapper: serviceLocator<RepositoryErrorUIMapper>(),
      ),
    );
  }

  // Feature cubits
  if (!serviceLocator.isRegistered<PokemonListCubit>()) {
    serviceLocator.registerFactory<PokemonListCubit>(
          () => PokemonListCubit(
        getPokemonListUseCase: serviceLocator<GetPokemonListUseCase>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<PokemonDetailCubit>()) {
    serviceLocator.registerFactory<PokemonDetailCubit>(
          () => PokemonDetailCubit(
        getPokemonDetailUseCase: serviceLocator<GetPokemonDetailUseCase>(),
      ),
    );
  }
}