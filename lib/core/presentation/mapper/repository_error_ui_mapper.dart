import '../../domain/error/repository_error.dart';
import '../error/ui_error.dart';

final class RepositoryErrorUIMapper {
  const RepositoryErrorUIMapper();

  UiError map(RepositoryError error) {
    return switch (error) {
      RepositoryNetworkError(message: final msg) => UiNetworkError(message: msg),
      RepositoryParsingError(message: final msg) => UiParsingError(message: msg),
      RepositoryUnknownError(message: final msg) => UiUnknownError(message: msg),
    };
  }
}