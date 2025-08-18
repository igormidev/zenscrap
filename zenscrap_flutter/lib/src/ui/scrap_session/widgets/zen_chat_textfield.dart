import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:zenscrap_flutter/src/states/chat_session/chat_scroll_controller_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_textfield.dart';

class ZenChatTextfield extends ConsumerStatefulWidget {
  const ZenChatTextfield({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ZenChatTextfieldState();
}

class _ZenChatTextfieldState extends ConsumerState<ZenChatTextfield> {
  final TextEditingController _promptEC = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _promptEC.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      ref.read(chatScrollHelperProvider).scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isLoading) return;

    final message = _promptEC.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(scrapChatProvider.notifier).sendMessage(message);
      _promptEC.clear();
      _formKey.currentState?.reset();
      ref.read(chatScrollHelperProvider).scrollToBottom();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ZenTextfield(
              controller: _promptEC,
              focusNode: _focusNode,
              labelText: 'Ask for any modification...',
              hintText: '',
              minLines: 1,
              maxLines: 5,
              enabled: !_isLoading,
              onSubmitted: (_) => _sendMessage(),
              validator: ValidationBuilder()
                  .minLength(3, 'Message must be at least 3 characters')
                  .maxLength(1000, 'Message must be less than 1000 characters')
                  .build(),
            ),
          ),
        const SizedBox(width: 8),
        Material(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _isLoading ? null : _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 24,
                    ),
            ),
          ),
        ),
      ],
    ),
    );
  }
}
