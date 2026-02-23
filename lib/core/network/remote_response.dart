sealed class PokeApiRemoteResponse<T> {
  const PokeApiRemoteResponse();
}

final class PokeApiSuccess<T> extends PokeApiRemoteResponse<T> {
  const PokeApiSuccess(this.data);

  final T data;
}

final class PokeApiFailure<T> extends PokeApiRemoteResponse<T> {
  const PokeApiFailure({
    required this.error,
    this.stackTrace,
  });

  final PokeApiRemoteError error;
  final StackTrace? stackTrace;
}

sealed class PokeApiRemoteError {
  const PokeApiRemoteError();
}

final class PokeApiNetworkError extends PokeApiRemoteError {
  const PokeApiNetworkError({required this.message});
  final String message;
}

final class PokeApiParsingError extends PokeApiRemoteError {
  const PokeApiParsingError({required this.message});
  final String message;
}

final class PokeApiUnknownError extends PokeApiRemoteError {
  const PokeApiUnknownError({required this.message});
  final String message;
}