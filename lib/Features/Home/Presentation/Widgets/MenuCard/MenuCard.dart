import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 3D Tilt Menu Card for Home Screen Services.
class MenuCard extends StatefulWidget {
  final IconData? icon;
  final String? assetPath;
  final Color iconColor;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    this.icon,
    this.assetPath,
    required this.iconColor,
    this.onTap,
  }) : assert(
          icon != null || assetPath != null,
          'Either icon or assetPath must be provided',
        );

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
            child: SizedBox(
              width: 60,
              height: 60,
              child: Center(child: _buildIcon()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    const iconSize = 40.0;
    final assetPath = widget.assetPath;
    if (assetPath != null && assetPath.isNotEmpty) {
      final lower = assetPath.toLowerCase();
      if (lower.endsWith('.svg')) {
        return SvgPicture.asset(
          assetPath,
          width: iconSize,
          height: iconSize,
          placeholderBuilder: (_) => _fallbackIcon(size: iconSize),
        );
      }
      return Image.asset(
        assetPath,
        width: iconSize,
        height: iconSize,
        errorBuilder: (_, _, _) => _fallbackIcon(size: iconSize),
      );
    }
    return _fallbackIcon(size: iconSize);
  }

  Widget _fallbackIcon({double size = 40}) {
    return Icon(
      widget.icon ?? Icons.image_outlined,
      color: widget.iconColor,
      size: size,
    );
  }
}
