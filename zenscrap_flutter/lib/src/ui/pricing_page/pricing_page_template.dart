import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:babel_text/babel_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/src/ui/pricing_page/prices_model.dart';

class PricingPage extends StatefulWidget {
  final int crossAxisCount;
  final double width;
  final BoxDecoration Function(BoxDecoration decoration)? decorationMapper;
  final List<PricesModel> pricesList;
  final double childAspectRatio;
  final String title;
  final String subtitle;
  final String payMonthly;
  final String payYearly;
  final String perYearText;
  final String perMonthText;
  final String buttonName;
  final bool forceAllColumnsToHaveSameSizeInDesktop;
  const PricingPage({
    super.key,
    required this.pricesList,
    int? crossAxisCount,
    this.title = 'Pricing',
    required this.subtitle,
    this.buttonName = 'START NOW',
    this.perYearText = 'START NOW',
    this.perMonthText = 'START NOW',
    this.payMonthly = 'Pay monthly',
    this.payYearly = 'Pay yearly',
    this.decorationMapper,
    this.childAspectRatio = 1,
    this.width = double.infinity,
    this.forceAllColumnsToHaveSameSizeInDesktop = false,
  }) : crossAxisCount = crossAxisCount ?? pricesList.length;

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  bool isYearly = false;
  bool didSwitchAnimation = false;
  final ValueNotifier<int?> loadingIndex = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _timer?.cancel();
    loadingIndex.dispose();
    super.dispose();
  }

  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(30),
          spreadRadius: 2,
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    );

    final decoration =
        widget.decorationMapper?.call(defaultDecoration) ?? defaultDecoration;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 900;

        double fontSize;
        double titleFontSize;
        double priceFontSize;
        double toggleFontSize;
        double spacing;

        if (isMobile) {
          fontSize = 14;
          titleFontSize = 32;
          priceFontSize = 36;
          toggleFontSize = 16;
          spacing = 16;
        } else {
          fontSize = 16;
          titleFontSize = 40;
          priceFontSize = 40;
          toggleFontSize = 20;
          spacing = 20;
        }

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : widget.width,
                minHeight: isMobile ? 0 : constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 0,
                  vertical: isMobile ? 40 : 0,
                ),
                child: Column(
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    BabelText(
                      '<b>${widget.title}<b>',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: isMobile ? 16 : 8),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 20,
                      ),
                      child: BabelText(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: fontSize + (isMobile ? 1 : 0),
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.outline,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: isMobile ? 32 : spacing),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withAlpha(100),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8 : 12,
                        vertical: isMobile ? 4 : 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BabelText(
                            widget.payMonthly,
                            style: TextStyle(
                              fontSize: toggleFontSize,
                              fontWeight: !isYearly
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          Switch(
                            value: isYearly,
                            onChanged: (value) {
                              setState(() {
                                isYearly = value;
                              });
                              _timer?.cancel();
                              _timer = Timer(Duration(milliseconds: 700), () {
                                setState(() {
                                  didSwitchAnimation = !didSwitchAnimation;
                                });
                              });
                            },
                          ),
                          BabelText(
                            widget.payYearly,
                            style: TextStyle(
                              fontSize: toggleFontSize,
                              fontWeight: isYearly
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isMobile ? 40 : spacing * 1.8),
                    if (isMobile)
                      Column(
                        children: widget.pricesList.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final price = entry.value;
                          final tileDec =
                              price.decoration ??
                              decoration.copyWith(
                                border: price.emphasisText != null
                                    ? Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 3,
                                      )
                                    : null,
                              );
                          return Padding(
                            padding: EdgeInsets.only(bottom: 28),
                            child: _buildPricingCard(
                              context,
                              index,
                              price,
                              tileDec,
                              isMobile,
                              fontSize,
                              priceFontSize,
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 300),
                              child: Transform.scale(
                                scale: 1.14,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 4,
                                  children: List.generate(8, (index) => _row),
                                ),
                              ),
                            ),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (widget
                                  .forceAllColumnsToHaveSameSizeInDesktop) {
                                return IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: widget.pricesList
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final index = entry.key;
                                          final price = entry.value;
                                          final tileDec =
                                              price.decoration ??
                                              decoration.copyWith(
                                                border:
                                                    price.emphasisText != null
                                                    ? Border.all(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                        width: 5,
                                                      )
                                                    : null,
                                              );
                                          return Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right:
                                                    index <
                                                        widget
                                                                .pricesList
                                                                .length -
                                                            1
                                                    ? spacing * 0.8
                                                    : 0,
                                              ),
                                              child: _buildPricingCard(
                                                context,
                                                index,
                                                price,
                                                tileDec,
                                                false,
                                                fontSize,
                                                priceFontSize,
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                                );
                              } else {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widget.pricesList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        final index = entry.key;
                                        final price = entry.value;
                                        final tileDec =
                                            price.decoration ??
                                            decoration.copyWith(
                                              border: price.emphasisText != null
                                                  ? Border.all(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                      width: 5,
                                                    )
                                                  : null,
                                            );
                                        return Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right:
                                                  index <
                                                      widget.pricesList.length -
                                                          1
                                                  ? spacing * 0.8
                                                  : 0,
                                            ),
                                            child: _buildPricingCard(
                                              context,
                                              index,
                                              price,
                                              tileDec,
                                              false,
                                              fontSize,
                                              priceFontSize,
                                            ),
                                          ),
                                        );
                                      })
                                      .toList(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    int index,
    PricesModel price,
    BoxDecoration tileDec,
    bool isMobile,
    double fontSize,
    double priceFontSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: tileDec,
              padding: EdgeInsets.all(isMobile ? 20 : 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (price.emphasisText != null && !isMobile)
                    SizedBox(height: 6),
                  BabelText(
                    price.title,
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 16),
                  if (isMobile)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$',
                              style: TextStyle(
                                fontSize: priceFontSize * 0.5,
                                fontWeight: FontWeight.w400,
                                height: 1.8,
                              ),
                            ),
                            AnimatedFlipCounter(
                              duration: Duration(milliseconds: 500),
                              value: isYearly
                                  ? (price.yearlyPrice / 12).ceil()
                                  : price.monthlyPrice,
                              textStyle: TextStyle(
                                fontSize: priceFontSize,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          isYearly
                              ? '${widget.perMonthText} (billed yearly)'
                              : widget.perMonthText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  if (!isMobile)
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Stack(
                        children: [
                          Align(
                                alignment: Alignment(-0.6, 0),
                                child: Column(
                                  children: [
                                    AnimatedFlipCounter(
                                      duration: Duration(milliseconds: 500),
                                      value: isYearly
                                          ? (price.yearlyPrice / 12).ceil()
                                          : price.monthlyPrice,
                                      textStyle: TextStyle(
                                        fontSize: priceFontSize,
                                        fontWeight: FontWeight.w300,
                                        height: 0.85,
                                      ),
                                    ),
                                    Text(
                                      widget.perMonthText,
                                      style: TextStyle(
                                        fontSize: fontSize * 0.875,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate(target: didSwitchAnimation ? 1 : 0)
                              .slideX(begin: 0.22),
                          Center(
                                child: VerticalDivider(
                                  indent: 6,
                                  endIndent: 6,
                                  color: Colors.grey,
                                ),
                              )
                              .animate(target: didSwitchAnimation ? 1 : 0)
                              .fadeIn(),
                          Align(
                                alignment: Alignment(0.8, 0),
                                child: Column(
                                  children: [
                                    AnimatedFlipCounter(
                                      duration: Duration(milliseconds: 500),
                                      value: price.yearlyPrice,
                                      textStyle: TextStyle(
                                        fontSize: priceFontSize,
                                        fontWeight: FontWeight.w300,
                                        height: 0.85,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      widget.perYearText,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: fontSize * 0.875,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate(target: didSwitchAnimation ? 1 : 0)
                              .fadeIn(),
                        ],
                      ),
                    ),
                  SizedBox(height: isMobile ? 24 : 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: isMobile ? 10 : 12,
                    children: price.advantagesListage.map((advantage) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : 12,
                          vertical: isMobile ? 10 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: BabelText(
                          '@@ $advantage',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : fontSize,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                          innerWidgetMapping: {
                            '@@': (context, text) => BabelWidget(
                              child: Icon(
                                Icons.check_circle,
                                size: isMobile ? 20 : 22,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (price.emphasisText != null)
              Positioned(
                top: -12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(80),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(
                      price.emphasisText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 12),
        if (price.emphasisText != null)
          ValueListenableBuilder<int?>(
            valueListenable: loadingIndex,
            builder: (context, currentLoadingIndex, child) {
              final isLoading = currentLoadingIndex == index;
              final isDisabled = currentLoadingIndex != null;
              return IgnorePointer(
                ignoring: isDisabled,
                child: FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (isDisabled) return;
                          loadingIndex.value = index;
                          try {
                            await price.onTap.call(isYearly);
                          } finally {
                            loadingIndex.value = null;
                          }
                        },
                  style: FilledButton.styleFrom(
                    fixedSize: Size.fromHeight(isMobile ? 48 : 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: isLoading ? Colors.grey : null,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          widget.buttonName,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              );
            },
          ),
        if (price.emphasisText == null)
          ValueListenableBuilder<int?>(
            valueListenable: loadingIndex,
            builder: (context, currentLoadingIndex, child) {
              final isLoading = currentLoadingIndex == index;
              final isDisabled = currentLoadingIndex != null;
              return OutlinedButton(
                onPressed: isDisabled
                    ? null
                    : () async {
                        loadingIndex.value = index;
                        try {
                          await price.onTap.call(isYearly);
                        } finally {
                          loadingIndex.value = null;
                        }
                      },
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromHeight(isMobile ? 48 : 48),
                  backgroundColor: isLoading
                      ? Colors.grey.withValues(alpha: 0.3)
                      : tileDec.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: isLoading
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                    width: isMobile ? 2 : 2.5,
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : Text(
                        widget.buttonName,
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
              );
            },
          ),
      ],
    );
  }
}

const _circle = Icon(
  Icons.circle,
  size: 12,
  color: Color.fromARGB(97, 191, 191, 191),
);

final _row = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  spacing: 4,
  children: List.generate(50, (index) => _circle),
);
