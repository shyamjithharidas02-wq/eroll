import 'package:animate_do/animate_do.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:eroll/core/constants/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../models/onboard_slide.dart';
import '../widgets/onboard_pill.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  final _controller = PageController();
  final _slides = OnboardSlide.all;
  int _index = 0;

  bool get _isLast => _index == _slides.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() =>
      Navigator.pushReplacementNamed(context, AppRouteNames.setPinPage);

  /// Skip jumps to the last slide; "Get started" there enters the app.
  void _skip() => _controller.animateToPage(
    _slides.length - 1,
    duration: const Duration(milliseconds: 450),
    curve: Curves.easeOutCubic,
  );

  void _next() {
    if (_isLast) return _finish();
    _controller.nextPage(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: _Background()),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const Gap(14),
                  _Header(onSkip: _isLast ? null : _skip),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _slides.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
                    ),
                  ),
                  _Dots(count: _slides.length, index: _index),
                  const Gap(46),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _ContinueButton(
                      label: _isLast ? 'Get started' : 'Continue',
                      onTap: _next,
                    ),
                  ),
                  Gap(bottomInset > 0 ? bottomInset + 6 : 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft lime (top-left) and mint (right) glow fading into off-white.
class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDEEBD3), Color(0xFFE6EEE4), Color(0xFFF5F8F4)],
          stops: [0.0, 0.55, 0.8],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-1.1, -0.35),
                radius: 1.0,
                colors: [Color(0xFFDDEDC4), Color(0x00DDEDC4)],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(1.2, -0.2),
                radius: 0.9,
                colors: [Color(0xFFC4DECF), Color(0x00C4DECF)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  /// Null hides Skip (on the last slide).
  final VoidCallback? onSkip;

  const _Header({this.onSkip});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Semantics(
            label: 'Kinar',
            image: true,
            child: Image.asset(
              AssetPath.kinarWordmark,
              width: 98,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned(
            right: 12,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: onSkip == null ? 0 : 1,
              child: IgnorePointer(
                ignoring: onSkip == null,
                child: TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF55635B),
                    textStyle: context.textTheme.headlineSmall!.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  child: const Text('Skip'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final OnboardSlide slide;

  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    const frame = OnboardSlide.frame;

    return Column(
      children: [
        const Gap(14),
        // Pill cluster, scaled down on short screens.
        Expanded(
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            child: SizedBox.fromSize(
              size: frame,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (final (i, pill) in slide.pills.indexed)
                    Positioned(
                      left: pill.center.dx,
                      top: pill.center.dy,
                      child: FractionalTranslation(
                        translation: const Offset(-0.5, -0.5),
                        child: FadeInUp(
                          from: 18,
                          delay: Duration(milliseconds: 60 * i),
                          duration: const Duration(milliseconds: 420),
                          child: OnboardPill(data: pill),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const Gap(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineLarge!.copyWith(
                  fontSize: 30,
                  height: 1.12,
                  letterSpacing: -0.6,
                  color: AppColors.ink,
                ),
              ),
              const Gap(14),
              Text(
                slide.body,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontSize: 15.5,
                  height: 1.5,
                  color: const Color(0xFF55635B),
                ),
              ),
            ],
          ),
        ),
        const Gap(26),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${index + 1} of $count',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: i == index ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: i == index ? AppColors.ink : const Color(0xFFC5CEC7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ContinueButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(29);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF28594B), Color(0xFF142921)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: SizedBox(
            height: 58,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    label,
                    key: ValueKey(label),
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontSize: 17,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const Gap(12),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
