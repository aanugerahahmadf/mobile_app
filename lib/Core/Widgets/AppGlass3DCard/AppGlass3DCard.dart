import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Premier Glass Modern 3D Card for the Wedding Flowers Decoration App.
/// Features:
/// - Real-time frosted glassmorphism (BackdropFilter blur)
/// - Interactive 3D Perspective Tilt using Matrix4
/// - Dynamic specular light sheen / glare that follows the tilt angle
/// - Auto-adaptation to Light, Dark (Night), and System modes
class AppGlass3DCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double maxTiltAngle;
  final double blurSigma;
  final double? width;
  final double? height;
  final bool enable3D;
  final bool enableGlare;
  final BoxBorder? customBorder;

  const AppGlass3DCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.maxTiltAngle = 0.18, // radians (~10 degrees)
    this.blurSigma = 16.0,
    this.width,
    this.height,
    this.enable3D = true,
    this.enableGlare = true,
    this.customBorder,
  });

  @override
  State<AppGlass3DCard> createState() => _AppGlass3DCardState();
}

class _AppGlass3DCardState extends State<AppGlass3DCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _resetController;
  late Animation<double> _rotXAnim;
  late Animation<double> _rotYAnim;
  late Animation<double> _scaleAnim;

  double _rotX = 0.0;
  double _rotY = 0.0;
  double _scale = 1.0;
  Offset _glareAlignment = Offset.zero;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _rotXAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
    );
    _rotYAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 1, end: 1).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
    );

    _resetController.addListener(() {
      setState(() {
        _rotX = _rotXAnim.value;
        _rotY = _rotYAnim.value;
        _scale = _scaleAnim.value;
        _glareAlignment = Offset(-_rotY / widget.maxTiltAngle, -_rotX / widget.maxTiltAngle);
      });
    });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _updateTilt(Offset localPos, Size size) {
    if (!widget.enable3D || size.width == 0 || size.height == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    // Normalised offset (-1.0 to 1.0)
    final dx = ((localPos.dx - center.dx) / (size.width / 2)).clamp(-1.0, 1.0);
    final dy = ((localPos.dy - center.dy) / (size.height / 2)).clamp(-1.0, 1.0);

    setState(() {
      _rotX = -dy * widget.maxTiltAngle;
      _rotY = dx * widget.maxTiltAngle;
      _scale = 0.985;
      _glareAlignment = Offset(dx, dy);
    });
  }

  void _onPointerDown(PointerDownEvent event, Size size) {
    if (!widget.enable3D) return;
    _resetController.stop();
    HapticFeedback.selectionClick();
    _updateTilt(event.localPosition, size);
  }

  void _onPointerMove(PointerMoveEvent event, Size size) {
    _updateTilt(event.localPosition, size);
  }

  void _onPointerUp(PointerUpEvent event) {
    _resetTilt();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _resetTilt();
  }

  void _resetTilt() {
    if (!widget.enable3D) return;
    _rotXAnim = Tween<double>(begin: _rotX, end: 0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
    );
    _rotYAnim = Tween<double>(begin: _rotY, end: 0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: _scale, end: 1.0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
    );
    _resetController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Glass aesthetics tuned for wedding luxury in both Light and Night modes
    final glassColor = isDark
        ? const Color(0x381E293B) // Smoked charcoal obsidian frost
        : const Color(0x9EFFFFFF); // Crystal ivory/white frost

    final specularBorder = widget.customBorder ??
        Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.65),
          width: 1.2,
        );

    final cardShadow = [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.45)
            : const Color(0xFF1E3A5F).withValues(alpha: 0.08),
        blurRadius: 22,
        offset: Offset(0, 8 + (_scale < 1.0 ? 2 : 0)),
      ),
      if (isDark)
        BoxShadow(
          color: const Color(0xFFC9A94E).withValues(alpha: 0.06), // subtle champagne glow
          blurRadius: 18,
          offset: const Offset(0, 0),
        ),
    ];

    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          // 3D Matrix perspective transformation
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.0012) // 3D Perspective factor
            ..scaleByDouble(_scale, _scale, 1.0, 1.0)
            ..rotateX(_rotX)
            ..rotateY(_rotY);

          return Listener(
            onPointerDown: (e) => _onPointerDown(e, size),
            onPointerMove: (e) => _onPointerMove(e, size),
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Transform(
                transform: transform,
                alignment: FractionalOffset.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: widget.blurSigma,
                        sigmaY: widget.blurSigma,
                      ),
                      child: Container(
                        padding: widget.padding,
                        decoration: BoxDecoration(
                          color: glassColor,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          border: specularBorder,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    Colors.white.withValues(alpha: 0.12),
                                    Colors.white.withValues(alpha: 0.02),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.70),
                                    Colors.white.withValues(alpha: 0.35),
                                  ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            widget.child,

                            // Dynamic 3D specular light glare layer
                            if (widget.enable3D && widget.enableGlare)
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        widget.borderRadius,
                                      ),
                                      gradient: RadialGradient(
                                        center: Alignment(
                                          _glareAlignment.dx,
                                          _glareAlignment.dy,
                                        ),
                                        radius: 0.9,
                                        colors: [
                                          (isDark
                                                  ? const Color(0xFFC9A94E)
                                                  : Colors.white)
                                              .withValues(
                                            alpha: isDark ? 0.15 : 0.30,
                                          ),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
