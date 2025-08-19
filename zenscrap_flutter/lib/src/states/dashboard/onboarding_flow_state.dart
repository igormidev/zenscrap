import 'package:freezed_annotation/freezed_annotation.dart';
part 'onboarding_flow_state.freezed.dart';

@freezed
abstract class OnboardingFlowState with _$OnboardingFlowState {
  factory OnboardingFlowState.none() = _OnboardingFlowStateNone;

  factory OnboardingFlowState.pendingPaymentFromUser() =
      _OnboardingFlowStatePendingPaymentFromUser;

  factory OnboardingFlowState.everythingOk() = _OnboardingFlowStateEverythingOk;
}

extension OnboardingFlowStateX on OnboardingFlowState {
  bool get isOnboardingFlowFinished => maybeMap(
        everythingOk: (_) => true,
        orElse: () => false,
      );
}
