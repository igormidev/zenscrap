import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';

class UserEditableProfileImage extends ConsumerStatefulWidget {
  const UserEditableProfileImage({
    super.key,
    required this.user,
  });

  final UserInfo? user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserEditableProfileImageState();
}

class _UserEditableProfileImageState
    extends ConsumerState<UserEditableProfileImage> {
  final ValueNotifier<bool> isUpdatingImage = ValueNotifier<bool>(false);

  @override
  void dispose() {
    super.dispose();
    isUpdatingImage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: isUpdatingImage,
            builder: (context, value, child) {
              if (value) {
                return Center(
                  child: Text(
                    'Loading...',
                    style: context.t.displaySmall,
                  ),
                );
              }

              return CircularUserImage(
                size: 200,
                userInfo: widget.user,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: context.c.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Tooltip(
                message: 'Change image',
                child: InkWell(
                  onTap: () async {
                    AccountInfo? user;
                    await ref.globalLoadingSetter(() async {
                      isUpdatingImage.value = true;
                      await ImageUploader.updateUserImage(
                        context: context,
                        sessionManager: ref.read(sessionManagerProvider),
                      );
                      user = await ref.read(accountProvider.notifier).getUser();

                      isUpdatingImage.value = false;
                    });
                    if (user != null) {
                      ref.read(accountProvider.notifier).setUser(user!);
                    }
                  },
                  child: const Icon(
                    Icons.cameraswitch_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
