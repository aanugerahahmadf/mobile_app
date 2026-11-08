import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Glass Modern + 3D Tilt Menu Card for Home Screen Services.
class MenuCard extends StatefulWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> with SingleTickerProviderStateMixin {
  double _rotX = 0, _rotY = 0, _scale = 1;
  late final AnimationController _ctrl;
  late Animation<double> _animRx, _animRy, _animSc;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animRx = _animRy = const AlwaysStoppedAnimation(0);
    _animSc = const AlwaysStoppedAnimation(1);
    _ctrl.addListener(() {
      setState(() {
        _rotX = _animRx.value;
        _rotY = _animRy.value;
        _scale = _animSc.value;
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDown(PointerDownEvent e) {
    _ctrl.stop();
    HapticFeedback.selectionClick();
    setState(() {
      _scale = 0.90;
      _rotX = 0.15;
      _rotY = -0.1;
    });
  }

  void _onUp(PointerUpEvent e) => _spring();
  void _onCancel(PointerCancelEvent e) => _spring();

  void _spring() {
    _animRx = Tween<double>(begin: _rotX, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _animRy = Tween<double>(begin: _rotY, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _animSc = Tween<double>(begin: _scale, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassColor = isDark
        ? widget.bgColor.withValues(alpha: 0.18)
        : widget.bgColor.withValues(alpha: 0.72);

    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.002)
      ..scaleByDouble(_scale, _scale, 1.0, 1.0)
      ..rotateX(_rotX)
      ..rotateY(_rotY);

    return Listener(
      onPointerDown: _onDown,
      onPointerUp: _onUp,
      onPointerCancel: _onCancel,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Transform(
            transform: transform,
            alignment: FractionalOffset.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.iconColor.withValues(alpha: isDark ? 0.25 : 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: glassColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.70),
                        width: 1.2,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.12 : 0.55),
                          Colors.white.withValues(alpha: isDark ? 0.02 : 0.15),
                        ],
                      ),
                    ),
                    child: Icon(widget.icon, color: widget.iconColor, size: 26),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
