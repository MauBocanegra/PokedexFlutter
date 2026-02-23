import 'package:equatable/equatable.dart';

import '../../../../../core/presentation/state/screen_view_state.dart';

final class SplashUIState extends Equatable {
  const SplashUIState({
    required this.viewState,
  });

  factory SplashUIState.initial() => const SplashUIState(viewState: LoadingState());

  final ScreenViewState viewState;

  SplashUIState copyWith({
    ScreenViewState? viewState,
  }) {
    return SplashUIState(
      viewState: viewState ?? this.viewState,
    );
  }

  @override
  List<Object?> get props => [viewState];
}