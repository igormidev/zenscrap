import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class EditScrappableDialog extends ConsumerStatefulWidget {
  final Scrappable scrappable;
  final Future<bool> Function(String name, String description) onSave;

  const EditScrappableDialog({
    super.key,
    required this.scrappable,
    required this.onSave,
  });

  @override
  ConsumerState<EditScrappableDialog> createState() => _EditScrappableDialogState();
}

class _EditScrappableDialogState extends ConsumerState<EditScrappableDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _initialName;
  late String _initialDescription;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initialName = widget.scrappable.name;
    _initialDescription = widget.scrappable.description;
    _nameController = TextEditingController(text: _initialName);
    _descriptionController = TextEditingController(text: _initialDescription);
    _nameController.addListener(_checkForChanges);
    _descriptionController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _descriptionController.removeListener(_checkForChanges);
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final hasChanges = _nameController.text != _initialName ||
        _descriptionController.text != _initialDescription;
    
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_hasChanges || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await widget.onSave(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
      );

      if (success && mounted) {
        Navigator.of(context).pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update scrappable'),
            backgroundColor: context.c.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: context.c.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.c.primaryContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.c.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_note_rounded,
                      color: context.c.onPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Scrappable',
                          style: context.t.headlineSmall?.copyWith(
                            color: context.c.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Customize name and description',
                          style: context.t.bodySmall?.copyWith(
                            color: context.c.onPrimaryContainer.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: context.c.onPrimaryContainer.withAlpha(180),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: context.t.labelLarge?.copyWith(
                          color: context.c.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        enabled: !_isLoading,
                        maxLines: 1,
                        maxLength: 50,
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                          return Text(
                            '$currentLength/$maxLength',
                            style: context.t.labelSmall?.copyWith(
                              color: currentLength > maxLength! 
                                  ? context.c.error 
                                  : context.c.onSurfaceVariant.withAlpha(150),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter scrappable name',
                          filled: true,
                          fillColor: context.c.surfaceContainerHighest.withAlpha(100),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: context.c.outline.withAlpha(50),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: context.c.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.label_outline_rounded,
                            color: context.c.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
                  
                  const SizedBox(height: 20),
                  
                  // Description Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: context.t.labelLarge?.copyWith(
                          color: context.c.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        enabled: !_isLoading,
                        maxLines: 4,
                        maxLength: 220,
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                          return Text(
                            '$currentLength/$maxLength',
                            style: context.t.labelSmall?.copyWith(
                              color: currentLength > maxLength! 
                                  ? context.c.error 
                                  : context.c.onSurfaceVariant.withAlpha(150),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter scrappable description',
                          filled: true,
                          fillColor: context.c.surfaceContainerHighest.withAlpha(100),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: context.c.outline.withAlpha(50),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: context.c.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 60),
                            child: Icon(
                              Icons.description_outlined,
                              color: context.c.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: context.c.outline.withAlpha(100),
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: context.t.labelLarge?.copyWith(
                              color: context.c.onSurface,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: _hasChanges && !_isLoading ? _handleSave : null,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: context.c.primary,
                            disabledBackgroundColor: context.c.surfaceContainerHighest,
                          ),
                          icon: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.c.onSurfaceVariant,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.save_rounded,
                                  color: _hasChanges 
                                      ? context.c.onPrimary 
                                      : context.c.onSurfaceVariant,
                                ),
                          label: Text(
                            _isLoading ? 'Saving...' : 'Save Changes',
                            style: context.t.labelLarge?.copyWith(
                              color: _hasChanges 
                                  ? context.c.onPrimary 
                                  : context.c.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ],
        ),
      ).animate().scale(
        begin: const Offset(0.9, 0.9),
        end: const Offset(1, 1),
        duration: 200.ms,
        curve: Curves.easeOutBack,
      ),
    );
  }
}