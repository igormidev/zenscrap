import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_textfield.dart';

class ZenChatTextfield extends ConsumerStatefulWidget {
  const ZenChatTextfield({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ZenChatTextfieldState();
}

class _ZenChatTextfieldState extends ConsumerState<ZenChatTextfield> {
  final TextEditingController _promptEC = TextEditingController();

  @override
  void dispose() {
    _promptEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZenTextfield(
      controller: _promptEC,
      labelText: 'Ask for any modification...',
      hintText: '',
      minLines: 1,
      maxLines: 5,
    );
  }
}
