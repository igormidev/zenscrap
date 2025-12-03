import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class ZenAnimatedSwitch extends StatefulWidget {
  final TabController tabController;
  final List<AnimatedSwitchItem> tabs;
  const ZenAnimatedSwitch(
      {super.key, required this.tabController, required this.tabs});

  @override
  State<ZenAnimatedSwitch> createState() => _ZenAnimatedSwitchState();
}

class _ZenAnimatedSwitchState extends State<ZenAnimatedSwitch> {
  late int selectedTabIndex;

  @override
  void initState() {
    super.initState();
    selectedTabIndex = widget.tabController.index;
    widget.tabController.addListener(_setSelectedTabIndex);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_setSelectedTabIndex);
    super.dispose();
  }

  void _setSelectedTabIndex() {
    final currentTab = widget.tabController.index;

    setState(() {
      selectedTabIndex = currentTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusedColor = context.c.primary;
    final borderColor = context.c.primaryContainer;
    return Row(
      spacing: 16,
      children: widget.tabs.map((tab) {
        final isSelected = widget.tabs.indexOf(tab) == selectedTabIndex;
        return Expanded(
          child: InkWell(
            onTap: () {
              widget.tabController.animateTo(widget.tabs.indexOf(tab));
            },
            child: AnimatedContainer(
              margin: isSelected ? null : EdgeInsets.symmetric(vertical: 3),
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? focusedColor
                    : context.c.surfaceContainerLowest,
                // color: isSelected ? focusedColor : Colors.transparent,
                border: isSelected
                    ? Border.all(color: focusedColor, width: 3)
                    : Border.all(color: borderColor, width: 3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Text(
                    tab.label,
                    style: context.t.headlineSmall?.copyWith(
                      fontSize: tab.fontSize,
                      color: isSelected
                          ? context.c.onPrimary
                          : context.c.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AnimatedSwitchItem {
  final String label;
  final double? fontSize;

  const AnimatedSwitchItem(this.label, {this.fontSize});
}
