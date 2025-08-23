import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/ui/account/views/account_view.dart';

class DefaultSinglePageContainer extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;
  final String title;
  final Widget child;
  final List<Widget> bellowTitleChildren;
  const DefaultSinglePageContainer({
    super.key,
    required this.title,
    required this.child,
    this.bellowTitleChildren = const [],
    this.maxWidth = 600,
    this.maxHeight = 600,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = getStandardCardContainerDecoration(context);
    return DeafultSinglePage(
      title: title,
      maxWidth: maxWidth,
      children: [
        if (bellowTitleChildren.isEmpty) const SizedBox(height: 20),
        ...bellowTitleChildren,
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: decoration,
          child: child,
        ),
      ],
    );
  }
}

class DeafultSinglePage extends StatelessWidget {
  final String title;
  final double maxWidth;
  final double maxHeight;
  final Color? backgroundColor;
  final List<Widget> children;
  final List<Widget> aboveTitleChildren;
  final List<Widget> aboveButtonChildren;
  final EdgeInsetsGeometry padding;
  const DeafultSinglePage({
    super.key,
    required this.children,
    this.aboveButtonChildren = const [],
    this.aboveTitleChildren = const [],
    required this.title,
    this.backgroundColor,
    required this.maxWidth,
    this.maxHeight = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...aboveButtonChildren,
                if (context.canPop()) ...[
                  FilledButton.tonalIcon(
                    onPressed: () => context.pop(),
                    label: const Text('Back'),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 8),
                ],
                ...aboveTitleChildren,
                Text(title, style: Theme.of(context).textTheme.displayMedium),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
