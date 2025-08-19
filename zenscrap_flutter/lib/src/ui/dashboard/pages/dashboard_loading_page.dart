import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';

class DashboardLoadingPage extends StatefulWidget {
  final String? loadingMessage;
  final double? fontSize;
  const DashboardLoadingPage({super.key, this.loadingMessage, this.fontSize});

  @override
  State<DashboardLoadingPage> createState() => _DashboardLoadingPageState();
}

class _DashboardLoadingPageState extends State<DashboardLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlanetLoading(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Lottie.network(
              'https://lottie.host/45e3dbb6-b766-4539-b87d-1333016c46d8/Opr561EA9y.lottie',
              decoder: customDecoder,
              height: 200,
              width: 200,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 200.0),
            child: Text(
              widget.loadingMessage ?? 'Loading...',
              style: TextStyle(
                fontSize: widget.fontSize ?? 40,
                color: context.c.outline,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class PlanetLoading extends StatefulWidget {
  final double? opacity;
  const PlanetLoading({super.key, this.opacity});

  @override
  State<PlanetLoading> createState() => _PlanetLoadingState();
}

class _PlanetLoadingState extends State<PlanetLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundAnimation;
  @override
  void initState() {
    super.initState();
    _backgroundAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
  }

  @override
  void dispose() {
    _backgroundAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity ?? 0.8,
      child: Center(
        child: Lottie.network(
          'https://lottie.host/9f04317b-5f18-4e51-81a0-a655afded7de/bewKD4ffjO.lottie',
          decoder: customDecoder,
          fit: BoxFit.fitWidth,
          width: double.maxFinite,
          controller: _backgroundAnimation,
          onLoaded: (p0) => _backgroundAnimation.repeat(),
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 750),
          delay: const Duration(milliseconds: 200),
        );
  }
}
