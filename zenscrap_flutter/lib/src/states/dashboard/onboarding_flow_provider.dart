import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/dashboard/onboarding_flow_state.dart';

final Provider<OnboardingFlowState> onboardingFlowStateProvider =
    Provider<OnboardingFlowState>((ref) {
  final accountInfo = ref.watch(
    accountProvider.select(
      (value) => value.mapOrNull(withData: (value) => value.accountInfo),
    ),
  );
  if (accountInfo == null) {
    return OnboardingFlowState.none();
  }
  final bool doesNotHavePlan = accountInfo.planTier == PlanTier.none;

  if (doesNotHavePlan) {
    return OnboardingFlowState.pendingPaymentFromUser();
  }

  return OnboardingFlowState.everythingOk();
});
