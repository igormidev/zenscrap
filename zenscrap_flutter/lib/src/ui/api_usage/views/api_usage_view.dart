import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/design_system/elements/default_single_page_container.dart';

class ApiUsageView extends ConsumerStatefulWidget {
  const ApiUsageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApiUsageViewState();
}

class _ApiUsageViewState extends ConsumerState<ApiUsageView> {
  @override
  Widget build(BuildContext context) {
    return DefaultSinglePageContainer(
      title: 'Api usage',
      child: Container(),
    );
  }
}
