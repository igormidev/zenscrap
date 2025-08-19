import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/account_image.dart';

class CompactDashboardAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const CompactDashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountImageUrl = ref.watch(sessionProvider).mapOrNull(
          logged: (value) => value.user.imageUrl,
        );

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Text('Zen scrap'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AccountImage(image: accountImageUrl, size: 32),
        ),
      ],
    );
  }
}
