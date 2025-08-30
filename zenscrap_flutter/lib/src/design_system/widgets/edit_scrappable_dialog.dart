import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/scraper_category_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';

class EditScrappableDialog extends ConsumerStatefulWidget {
  final Scrappable scrappable;
  final Future<bool> Function(
      String name, String description, ScraperCategory? category) onSave;
  final Future<bool> Function()? onDelete;

  const EditScrappableDialog({
    super.key,
    required this.scrappable,
    required this.onSave,
    this.onDelete,
  });

  @override
  ConsumerState<EditScrappableDialog> createState() =>
      _EditScrappableDialogState();
}

class _EditScrappableDialogState extends ConsumerState<EditScrappableDialog> {
  final ValueNotifier<bool> _isDeleting = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isDeleting.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    if (widget.onDelete == null) return;

    await ref.globalLoadingSetter(() async {
      // Show confirmation dialog
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('Delete Scrappable'),
          content: Text(
              'Are you sure you want to delete "${widget.scrappable.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: context.c.error,
              ),
              child: Text('Delete'),
            ),
          ],
        ),
      );

      if (shouldDelete != true) return;

      _isDeleting.value = true;
      try {
        final success = await widget.onDelete!();
        if (success && mounted) {
          context.pop();
        } else if (mounted) {
          showErrorSnackbar(context, 'Failed to delete scrappable');
        }
      } catch (e) {
        if (mounted) {
          showErrorSnackbar(context, 'Error: ${e.toString()}');
        }
      } finally {
        if (mounted) {
          _isDeleting.value = false;
        }
      }
    });
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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: context.c.onPrimaryContainer.withAlpha(180),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0),

            ScrappableEditForm(
              scrappable: widget.scrappable,
              onSave: widget.onSave,
              shouldPopOnEnd: true,
            ),

            Transform.translate(
              offset: const Offset(0, -10),
              child: Row(
                children: [
                  Expanded(child: Divider(endIndent: 16, indent: 20)),
                  Text('OR'),
                  Expanded(child: Divider(indent: 16, endIndent: 20)),
                ],
              ),
            ),
            SizedBox(height: 6),

            Row(
              children: [
                SizedBox(width: 20),
                if (widget.onDelete != null)
                  ValueListenableBuilder<bool>(
                    valueListenable: _isDeleting,
                    builder: (context, isDeleting, child) {
                      return CircleAvatar(
                        backgroundColor: isDeleting
                            ? context.c.surfaceContainerHighest
                            : context.c.errorContainer,
                        child: isDeleting
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
                            : IconButton(
                                tooltip: 'Delete scrappable',
                                color: context.c.error,
                                onPressed: _handleDelete,
                                icon: Icon(Icons.delete),
                              ),
                      );
                    },
                  ),
                Spacer(),
                FilledButton(
                  onPressed: () {
                    ref.read(scrapChatProvider.notifier).reset();
                    context.go(
                        '/scrappable-form?id=${widget.scrappable.id.toString()}');
                  },
                  child: Text('Edit scrapper extract logic'),
                ),
                SizedBox(width: 20),
              ],
            ),

            SizedBox(height: 20)
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

class ScrappableEditForm extends StatefulWidget {
  final Scrappable scrappable;
  final Future<bool> Function(
      String name, String description, ScraperCategory? category) onSave;
  final bool shouldPopOnEnd;
  final List<Widget> children;
  const ScrappableEditForm({
    super.key,
    required this.scrappable,
    required this.onSave,
    required this.shouldPopOnEnd,
    this.children = const [],
  });

  @override
  State<ScrappableEditForm> createState() => _ScrappableEditFormState();
}

class _ScrappableEditFormState extends State<ScrappableEditForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _initialName;
  late String _initialDescription;
  late ScraperCategory _initialCategory;
  ScraperCategory? _selectedCategory;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initialName = widget.scrappable.name;
    _initialDescription = widget.scrappable.description;
    _initialCategory = widget.scrappable.category;
    _selectedCategory = _initialCategory;
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
        _descriptionController.text != _initialDescription ||
        _selectedCategory != _initialCategory;

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
      await Future.delayed(const Duration(seconds: 1));
      final success = await widget.onSave(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        _selectedCategory != _initialCategory ? _selectedCategory : null,
      );

      if (success && mounted) {
        if (widget.shouldPopOnEnd) {
          context.pop(true);
        } else {
          setState(() {
            _hasChanges = false;
          });
        }
      } else if (mounted) {
        showErrorSnackbar(
          context,
          'Failed to update scrappable',
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, 'Error: ${e.toString()}');
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
    return ListView(
      shrinkWrap: widget.shouldPopOnEnd ? true : false,
      children: [
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
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
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
                      fillColor:
                          context.c.surfaceContainerHighest.withAlpha(100),
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

              // Category Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: context.t.labelLarge?.copyWith(
                      color: context.c.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _isLoading
                        ? null
                        : () => _showCategorySelectionDialog(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: context.c.surfaceContainerHighest.withAlpha(100),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.c.outline.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            color: context.c.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedCategory!.displayName,
                              style: context.t.bodyLarge?.copyWith(
                                color: context.c.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: context.c.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1, end: 0),

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
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
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
                      fillColor:
                          context.c.surfaceContainerHighest.withAlpha(100),
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

              SizedBox(height: 16),
              // Action Buttons
              FilledButton.icon(
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
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

              ...widget.children.map(
                (child) => child
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideX(begin: -0.1, end: 0),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _showCategorySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.c.primaryContainer,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        color: context.c.onPrimaryContainer,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Select Category',
                          style: context.t.headlineSmall?.copyWith(
                            color: context.c.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(
                          Icons.close,
                          color: context.c.onPrimaryContainer.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ),
                // Category List
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: ScraperCategory.values.length,
                    itemBuilder: (context, index) {
                      final category = ScraperCategory.values[index];
                      final isSelected = category == _selectedCategory;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          selected: isSelected,
                          selectedTileColor:
                              context.c.primaryContainer.withAlpha(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? context.c.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.c.primary
                                  : context.c.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              category.icon,
                              size: 20,
                              color: isSelected
                                  ? context.c.onPrimary
                                  : context.c.onSurfaceVariant,
                            ),
                          ),
                          title: Text(
                            category.displayName,
                            style: context.t.bodyLarge?.copyWith(
                              color: context.c.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            category.description,
                            style: context.t.bodySmall?.copyWith(
                              color: context.c.onSurfaceVariant.withAlpha(180),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                              _checkForChanges();
                            });
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
