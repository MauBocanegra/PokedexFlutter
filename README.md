# PokedexFlutter

Flutter Pokedex app built with Clean Architecture and SOLID principles, using Cubit for state management, GoRouter for navigation, GetIt for dependency injection, and PokeAPI as the data source.

Data sources:
- API: `https://pokeapi.co/api/v2`
- List: `GET /pokemon?limit=20&offset=N`
- Detail: `GET /pokemon/{id}`
- Image (home sprites): `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/{id}.png`

---

## Screenshots

> Replace the paths below with your real screenshot filenames once uploaded.

![Pokemon List](./docs/screenshots/pokemon_list.png)
![Pokemon Detail](./docs/screenshots/pokemon_detail.png)

---

## Features

- Splash screen with initial navigation to the list
- Pokemon list with infinite scrolling (loads 20 more items near end of list)
- Pokemon detail screen showing:
    - Image + name
    - Height, weight
    - Types
    - Stats

---

## Tech Stack

- Routing: `go_router`
- DI: `get_it`
- State: `Cubit` (`flutter_bloc`)
- Functional error handling: `either_dart`
- Networking: `http`
- External links (available): `url_launcher`

---

## Architecture

Clean Architecture boundaries:

- **Presentation**
    - Screens / widgets
    - Cubits
    - UIStates + `ScreenViewState` (loading / error / success)
    - UIEntities (presentation-ready models)
    - UI errors (`UiError`)

- **Domain**
    - Use cases
    - Repository contracts (interfaces)
    - Domain models
    - Domain errors (`RepositoryError`)

- **Data / Infrastructure**
    - PokeAPI remote datasource + HTTP client
    - DTOs (API response contracts)
    - API-level response wrappers (`PokeApiRemoteResponse`)

### Layered Mapping Rules

- Remote datasource returns `PokeApiRemoteResponse<T>`
- Repository maps:
    - DTO → Domain model
    - `PokeApiRemoteError` → `RepositoryError`
- Use cases map:
    - Domain model → UIEntity
    - `RepositoryError` → `UiError`

---

## Data Flow

### List

1. `PokemonListScreen` creates `PokemonListCubit` and calls `loadInitial()`
2. Cubit calls `GetPokemonListUseCase(limit, offset)`
3. Use case calls `PokemonRepository.getPokemonList(limit, offset)`
4. Repository calls `PokemonRemoteDataSource.getPokemonList(limit, offset)`
5. Remote calls `/pokemon?limit=20&offset=N`, parses DTOs
6. Repository maps DTOs → domain models
7. Use case maps domain → `PokemonListUIEntity`
8. Cubit updates `PokemonListUIState`:
    - `LoadingState` / `ErrorState` / `SuccessState`
9. Scrolling near the end triggers `loadMore()` and appends items

### Detail

1. `PokemonDetailScreen(pokemonId)` creates `PokemonDetailCubit` and calls `load(pokemonId)`
2. Cubit calls `GetPokemonDetailUseCase(pokemonId)`
3. Use case calls `PokemonRepository.getPokemonDetail(pokemonId)`
4. Repository calls `PokemonRemoteDataSource.getPokemonDetail(pokemonId)`
5. Remote calls `/pokemon/{id}`, parses only required fields:
    - `height`, `weight`, `stats`, `types`
6. Repository maps DTO → domain `PokemonDetail`
7. Use case maps domain → `PokemonDetailUIEntity` (includes unit conversions)
8. Cubit updates `PokemonDetailUIState`

---

## Pagination

- Page size: `20`
- Offset = number of already loaded items
- Threshold-based fetch near end of list
- UI keeps main content on screen while loading more:
    - `isLoadingMore` controls footer spinner
    - `loadMoreErrorMessage` controls footer retry UI

---