sealed class UiError {
  const UiError({required this.message});

  final String message;
}

final class UiNetworkError extends UiError {
  const UiNetworkError({required super.message});
}

final class UiParsingError extends UiError {
  const UiParsingError({required super.message});
}

final class UiUnknownError extends UiError {
  const UiUnknownError({required super.message});
}