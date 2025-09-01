import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/states/chat_session/chat_scroll_controller_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_textfield.dart';

class ZenChatTextfield extends ConsumerStatefulWidget {
  final DateTime targetTime;
  const ZenChatTextfield({
    super.key,
    required this.targetTime,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ZenChatTextfieldState();
}

class _ZenChatTextfieldState extends ConsumerState<ZenChatTextfield> {
  bool isEndpointTimeExpired = false;
  final TextEditingController _promptEC = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Use targetTime
    final Duration whenWillEnd = widget.targetTime.difference(DateTime.now());
    _timer = Timer.periodic(whenWillEnd, (timer) {
      if (mounted) {
        setState(() {
          isEndpointTimeExpired = true;
        });
      }
    });
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _timer?.cancel();
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

    _promptEC.clear();
    _formKey.currentState?.reset();
    ref.read(chatScrollHelperProvider).scrollToBottom();

    try {
      await ref.read(scrapChatProvider.notifier).sendMessage(message);
      // The thinking message will be automatically removed by onChange when the response arrives
      ref.read(chatScrollHelperProvider).scrollToBottom();
    } catch (error, stackTrace) {
      talker.error('Failed to send message', error, stackTrace);
      ref.read(chatScrollHelperProvider).scrollToBottom();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isEndpointTimeExpired = widget.targetTime.isBefore(DateTime.now());
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              label: Text('Gemini 2.5-flash'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
                padding: EdgeInsets.zero,
                // textStyle: const TextStyle(fontSize: 12),
                // padding: const EdgeInsets.symmetric(
                //   horizontal: 8,
                //   vertical: 4,
                // ),
                // minimumSize: Size.zero,
                // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(Icons.keyboard_arrow_down),
            ),
          ),
          Row(
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
                  enabled: !isEndpointTimeExpired && !_isLoading,
                  onSubmitted: (_) => _sendMessage(),
                  validator: ValidationBuilder()
                      .minLength(3, 'Message must be at least 3 characters')
                      .maxLength(
                          1000, 'Message must be less than 1000 characters')
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
        ],
      ),
    );
  }
}
