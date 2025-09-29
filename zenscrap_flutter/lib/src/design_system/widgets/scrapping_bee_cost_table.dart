import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/scrapping_bee_extract_logic_extension.dart';

class ScrappingBeeCostTable extends StatelessWidget {
  const ScrappingBeeCostTable({
    super.key,
    required this.extractLogic,
  });

  final ScrappingBeeExtractLogic extractLogic;

  @override
  Widget build(BuildContext context) {
    final fieldCosts = extractLogic.fieldCosts;
    final totalCost = extractLogic.totalCreditCost;

    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLowest,
        border: Border.all(
          color: context.c.outline.withAlpha(60),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TableHeader(context: context),
          const Divider(height: 1),
          _TableRow(
            fieldName: 'Render JS',
            fieldValue: extractLogic.renderJs.toString(),
            cost: fieldCosts['renderJs'] ?? 0,
            context: context,
          ),
          _TableRow(
            fieldName: 'Wait',
            fieldValue: extractLogic.wait?.toString(),
            cost: fieldCosts['wait'] ?? 0,
            context: context,
          ),
          _TableRow(
            fieldName: 'Wait For',
            fieldValue: extractLogic.waitFor,
            cost: fieldCosts['waitFor'] ?? 0,
            context: context,
          ),
          _TableRow(
            fieldName: 'Wait Browser',
            fieldValue: extractLogic.waitBrowser,
            cost: fieldCosts['waitBrowser'] ?? 0,
            context: context,
          ),
          _TableRow(
            fieldName: 'Premium Proxy',
            fieldValue: extractLogic.premiumProxy.toString(),
            cost: fieldCosts['premiumProxy'] ?? 0,
            context: context,
          ),
          _TableRow(
            fieldName: 'Stealth Proxy',
            fieldValue: extractLogic.stealthProxy.toString(),
            cost: fieldCosts['stealthProxy'] ?? 0,
            context: context,
          ),
          _TableRow(
            fieldName: 'Country Code',
            fieldValue: extractLogic.countryCode,
            cost: fieldCosts['countryCode'] ?? 0,
            context: context,
          ),
          _TableRow(
            fieldName: 'Custom Google',
            fieldValue: extractLogic.customGoogle?.toString(),
            cost: fieldCosts['customGoogle'] ?? 0,
            context: context,
          ),
          const Divider(height: 1),
          _TotalRow(
            totalCost: totalCost,
            context: context,
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.c.primaryContainer.withAlpha(30),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Field',
              style: context.t.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Value',
              style: context.t.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Credits',
              style: context.t.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.fieldName,
    required this.fieldValue,
    required this.cost,
    required this.context,
  });

  final String fieldName;
  final String? fieldValue;
  final int cost;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final isNull = fieldValue == null || fieldValue == 'null';
    final displayValue = isNull ? 'Not set' : fieldValue!;
    final displayCost = isNull ? '-' : cost.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.c.outline.withAlpha(20),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              fieldName,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              displayValue,
              style: context.t.bodyMedium?.copyWith(
                color: isNull
                    ? context.c.onSurface.withAlpha(100)
                    : context.c.onSurface,
                fontStyle: isNull ? FontStyle.italic : FontStyle.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isNull
                    ? Colors.transparent
                    : cost > 0
                        ? context.c.errorContainer.withAlpha(30)
                        : context.c.primaryContainer.withAlpha(30),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                displayCost,
                style: context.t.bodyMedium?.copyWith(
                  color: isNull
                      ? context.c.onSurface.withAlpha(100)
                      : cost > 0
                          ? context.c.error
                          : context.c.primary,
                  fontWeight: cost > 0 ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.totalCost,
    required this.context,
  });

  final int totalCost;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.c.primaryContainer.withAlpha(20),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              'Total API Credits',
              style: context.t.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: context.c.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.c.primary.withAlpha(60),
                ),
              ),
              child: Text(
                totalCost.toString(),
                style: context.t.titleMedium?.copyWith(
                  color: context.c.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}