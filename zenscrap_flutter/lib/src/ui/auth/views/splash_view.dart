import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserAuthState();
    });
  }

  void _getUserAuthState() async {
    final sessionManager = ref.read(sessionManagerProvider);
    final signedInUser = sessionManager.signedInUser;
    if (signedInUser == null) {
      ref.read(sessionProvider.notifier).setState(SessionState.notSignedIn());
    } else {
      final email = signedInUser.email;
      final userName = signedInUser.userName;
      if (email == null || userName == null) {
        await sessionManager.signOutAllDevices();
        ref.read(sessionProvider.notifier).setState(SessionState.notSignedIn());
        return;
      }

      ref.read(sessionProvider.notifier).setState(SessionState.logged(
        user: UserModel(
          email: email,
          userName: userName,
          imageUrl: signedInUser.imageUrl,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
