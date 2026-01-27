import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/visual_effects_config.dart';

/// A container with gradient background
class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const GradientContainer({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: begin, end: end, colors: colors),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// A button with gradient background and optional glow effect
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color>? gradientColors;
  final bool showGlow;
  final Color? glowColor;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradientColors,
    this.showGlow = false,
    this.glowColor,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        widget.gradientColors ??
        [
          VisualEffectsConfig.primaryGradientStart,
          VisualEffectsConfig.primaryGradientEnd,
        ];

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height ?? 50,
          padding: widget.padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: VisualEffectsConfig.buttonGradientBeginAlign,
              end: VisualEffectsConfig.buttonGradientEndAlign,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(
              VisualEffectsConfig.buttonBorderRadius,
            ),
            boxShadow: widget.showGlow
                ? VisualEffectsConfig.createGlowEffect(
                    color: widget.glowColor ?? colors.first,
                  )
                : null,
          ),
          child: Center(
            child: widget.isLoading
                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                : Text(
                    widget.text,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// A card with gradient overlay and glass effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool showGlow;
  final Color? glowColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.showGlow = false,
    this.glowColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: VisualEffectsConfig.cardGradientBeginAlign,
          end: VisualEffectsConfig.cardGradientEndAlign,
          colors: const [
            VisualEffectsConfig.cardGradientStart,
            VisualEffectsConfig.cardGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(
          VisualEffectsConfig.cardBorderRadius,
        ),
        border: Border.all(
          color: CupertinoColors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: showGlow
            ? VisualEffectsConfig.createGlowEffect(color: glowColor)
            : [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          VisualEffectsConfig.cardBorderRadius,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          color: CupertinoColors.darkBackgroundGray.withOpacity(
            VisualEffectsConfig.glassEffectOpacity,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}

/// A shimmer loading effect widget
class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: baseColor ?? VisualEffectsConfig.shimmerBaseColor,
      highlightColor:
          highlightColor ?? VisualEffectsConfig.shimmerHighlightColor,
      period: Duration(milliseconds: VisualEffectsConfig.shimmerDuration),
      child: child,
    );
  }
}

/// A pulsing glow effect widget
class PulsingGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double maxOpacity;
  final double minOpacity;
  final Duration duration;

  const PulsingGlow({
    super.key,
    required this.child,
    this.glowColor = VisualEffectsConfig.primaryGlowColor,
    this.maxOpacity = 0.8,
    this.minOpacity = 0.3,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<PulsingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);
    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(_animation.value),
                blurRadius: VisualEffectsConfig.glowBlurRadius,
                spreadRadius: VisualEffectsConfig.glowSpreadRadius,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// A gradient background for entire screens
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;

  const GradientBackground({super.key, required this.child, this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: VisualEffectsConfig.backgroundGradientBeginAlign,
          end: VisualEffectsConfig.backgroundGradientEndAlign,
          colors:
              colors ??
              [
                VisualEffectsConfig.backgroundGradientStart,
                VisualEffectsConfig.backgroundGradientEnd,
              ],
        ),
      ),
      child: child,
    );
  }
}

/// An animated gradient border widget
class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final List<Color> gradientColors;
  final BorderRadius? borderRadius;
  final Duration duration;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
    required this.gradientColors,
    this.borderRadius,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: SweepGradient(
              colors: widget.gradientColors,
              transform: GradientRotation(_controller.value * 2 * 3.14159),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.borderWidth),
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.darkBackgroundGray,
                borderRadius: widget.borderRadius,
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
