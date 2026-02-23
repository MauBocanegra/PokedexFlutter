import 'package:equatable/equatable.dart';

import '../error/ui_error.dart';

sealed class ScreenViewState extends Equatable {
  const ScreenViewState();
}

final class LoadingState extends ScreenViewState {
  const LoadingState();

  @override
  List<Object?> get props => const [];
}

final class SuccessState extends ScreenViewState {
  const SuccessState();

  @override
  List<Object?> get props => const [];
}

final class ErrorState extends ScreenViewState {
  const ErrorState({required this.error});

  final UiError error;

  @override
  List<Object?> get props => [error];
}