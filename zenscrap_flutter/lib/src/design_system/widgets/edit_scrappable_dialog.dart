import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class EditScrappableDialog extends ConsumerStatefulWidget {
  final Scrappable scrappable;
  final Future<bool> Function(
      String name, String description, ScraperCategory? category) onSave;

  const EditScrappableDialog({
    super.key,
    required this.scrappable,
    required this.onSave,
  });

  @override
  ConsumerState<EditScrappableDialog> createState() =>
      _EditScrappableDialogState();
}

class _EditScrappableDialogState extends ConsumerState<EditScrappableDialog> {
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

            SizedBox(
              height: 400,
              child: ScrappableEditForm(
                  scrappable: widget.scrappable, onSave: widget.onSave),
            )
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
  const ScrappableEditForm(
      {super.key, required this.scrappable, required this.onSave});

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
      final success = await widget.onSave(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        _selectedCategory != _initialCategory ? _selectedCategory : null,
      );

      if (success && mounted) {
        context.pop(true);
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
    return ListView(
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
                              _getCategoryDisplayName(_selectedCategory!),
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

              SizedBox(height: 20),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
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
                      onPressed:
                          _hasChanges && !_isLoading ? _handleSave : null,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: context.c.primary,
                        disabledBackgroundColor:
                            context.c.surfaceContainerHighest,
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
        )
      ],
    );
  }

  String _getCategoryDisplayName(ScraperCategory category) {
    switch (category) {
      case ScraperCategory.general:
        return 'General';
      case ScraperCategory.fitness:
        return 'Fitness';
      case ScraperCategory.sports:
        return 'Sports';
      case ScraperCategory.esports:
        return 'E-sports';
      case ScraperCategory.health:
        return 'Health';
      case ScraperCategory.movies:
        return 'Movies';
      case ScraperCategory.jobs:
        return 'Jobs';
      case ScraperCategory.finance:
        return 'Finance';
      case ScraperCategory.location:
        return 'Location';
      case ScraperCategory.science:
        return 'Science';
      case ScraperCategory.gaming:
        return 'Gaming';
      case ScraperCategory.travel:
        return 'Travel';
      case ScraperCategory.social_media:
        return 'Social Media';
      case ScraperCategory.ecommerce:
        return 'E-commerce';
      case ScraperCategory.news:
        return 'News';
      case ScraperCategory.weather:
        return 'Weather';
      case ScraperCategory.education:
        return 'Education';
      case ScraperCategory.music:
        return 'Music';
      case ScraperCategory.books:
        return 'Books';
      case ScraperCategory.comics:
        return 'Comics';
      case ScraperCategory.anime:
        return 'Anime';
      case ScraperCategory.real_estate:
        return 'Real Estate';
      case ScraperCategory.food:
        return 'Food';
      case ScraperCategory.fashion:
        return 'Fashion';
      case ScraperCategory.security:
        return 'Security';
      case ScraperCategory.ai:
        return 'AI';
      case ScraperCategory.seo:
        return 'SEO';
      case ScraperCategory.lead_generation:
        return 'Lead Generation';
      case ScraperCategory.developer_tools:
        return 'Developer Tools';
      case ScraperCategory.automotive:
        return 'Automotive';
      case ScraperCategory.government:
        return 'Government';
      case ScraperCategory.cryptocurrency:
        return 'Cryptocurrency';
      case ScraperCategory.images:
        return 'Images';
      case ScraperCategory.videos:
        return 'Videos';
      case ScraperCategory.other:
        return 'Other';
    }
  }

  String _getCategoryDescription(ScraperCategory category) {
    switch (category) {
      case ScraperCategory.general:
        return 'General-purpose or uncategorized scrapers';
      case ScraperCategory.fitness:
        return 'Health and fitness related';
      case ScraperCategory.sports:
        return 'Traditional sports data';
      case ScraperCategory.esports:
        return 'E-sports (competitive gaming)';
      case ScraperCategory.health:
        return 'Healthcare and medicine';
      case ScraperCategory.movies:
        return 'Movies and TV information';
      case ScraperCategory.jobs:
        return 'Job listings and employment';
      case ScraperCategory.finance:
        return 'Finance, banking, stock market';
      case ScraperCategory.location:
        return 'Location-based data, maps, geocoding';
      case ScraperCategory.science:
        return 'Science, research, academic data';
      case ScraperCategory.gaming:
        return 'Video games (general gaming info)';
      case ScraperCategory.travel:
        return 'Travel, tourism, hospitality';
      case ScraperCategory.social_media:
        return 'Social networks and social media platforms';
      case ScraperCategory.ecommerce:
        return 'E-commerce and online shopping';
      case ScraperCategory.news:
        return 'News and journalism sites';
      case ScraperCategory.weather:
        return 'Weather and climate data';
      case ScraperCategory.education:
        return 'Educational content and e-learning';
      case ScraperCategory.music:
        return 'Music, audio streaming, artist info';
      case ScraperCategory.books:
        return 'Books, literature, libraries';
      case ScraperCategory.comics:
        return 'Comics, manga';
      case ScraperCategory.anime:
        return 'Anime and animation';
      case ScraperCategory.real_estate:
        return 'Real estate, housing, property listings';
      case ScraperCategory.food:
        return 'Food, recipes, restaurants';
      case ScraperCategory.fashion:
        return 'Fashion, style, beauty';
      case ScraperCategory.security:
        return 'Cybersecurity, threat intelligence';
      case ScraperCategory.ai:
        return 'Artificial intelligence, ML tools';
      case ScraperCategory.seo:
        return 'SEO tools, search engine data';
      case ScraperCategory.lead_generation:
        return 'Lead generation, marketing data';
      case ScraperCategory.developer_tools:
        return 'Developer tools, general web scraping utilities';
      case ScraperCategory.automotive:
        return 'Automotive, vehicles, car listings';
      case ScraperCategory.government:
        return 'Government data, public records';
      case ScraperCategory.cryptocurrency:
        return 'Cryptocurrency and blockchain data';
      case ScraperCategory.images:
        return 'Image platforms or photography';
      case ScraperCategory.videos:
        return 'Video platforms (e.g. streaming, video sharing)';
      case ScraperCategory.other:
        return 'Other or uncategorized';
    }
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
                              Icons.tag_rounded,
                              size: 20,
                              color: isSelected
                                  ? context.c.onPrimary
                                  : context.c.onSurfaceVariant,
                            ),
                          ),
                          title: Text(
                            _getCategoryDisplayName(category),
                            style: context.t.bodyLarge?.copyWith(
                              color: context.c.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            _getCategoryDescription(category),
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
