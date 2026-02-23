sealed class RepositoryError {
  const RepositoryError({required this.message});

  final String message;
}

final class RepositoryNetworkError extends RepositoryError {
  const RepositoryNetworkError({required super.message});
}

final class RepositoryParsingError extends RepositoryError {
  const RepositoryParsingError({required super.message});
}

final class RepositoryUnknownError extends RepositoryError {
  const RepositoryUnknownError({required super.message});
}