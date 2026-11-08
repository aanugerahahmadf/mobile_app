import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';

class VoucherCard extends StatelessWidget {
  final Map<String, dynamic> voucher;
  final VoidCallback? onTap;

  const VoucherCard({super.key, required this.voucher, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    final code = voucher['code'] as String? ?? 'PROMO';
    final desc = voucher['description'] as String? ?? l.voucherSpecialOffer;
    final discountRaw = voucher['discount_amount'] ?? voucher['discount'] ?? 0;
    final discountType = voucher['discount_type'] as String? ?? 'percentage';

    String discLabel = '';
    if (discountType == 'percentage') {
      final double val = discountRaw is num
          ? discountRaw.toDouble()
          : (double.tryParse(discountRaw.toString()) ?? 0.0);
      discLabel = '${val.toInt()}%';
    } else {
      final int val = discountRaw is num
          ? discountRaw.toInt()
          : (double.tryParse(discountRaw.toString())?.toInt() ?? 0);
      discLabel = val >= 1000 ? '${val ~/ 1000}k' : '$val';
    }

    final gradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF6B0F1A), Color(0xFF8B1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final shadowColor = isDark
        ? const Color(0xFF8B0000).withAlpha(120)
        : const Color(0xFFFF4B2B).withAlpha(100);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: shadowColor, blurRadius: 14, offset: const Offset(0, 6)),
              if (isDark)
                BoxShadow(
                  color: const Color(0xFFC9A94E).withAlpha(30),
                  blurRadius: 20,
                ),
            ],
          ),
          child: ClipPath(
            clipper: TicketClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(gradient: gradient),
                child: Stack(
                  children: [
                    // Shimmer top edge glow
                    Positioned(
                      top: 0, left: 0, right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.55),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Background orb decorations
                    Positioned(
                      right: -20, top: -20,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withAlpha(25),
                      ),
                    ),
                    Positioned(
                      left: -30, bottom: -30,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withAlpha(15),
                      ),
                    ),
                    // Content
                    Row(
                      children: [
                        Container(
                          width: 80,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (discountType == 'fixed')
                                Text(
                                  'POTONGAN',
                                  style: TextStyle(
                                    fontSize: 7, fontWeight: FontWeight.w600,
                                    color: Colors.white.withAlpha(204), letterSpacing: 1.0,
                                  ),
                                ),
                              Text(
                                discLabel,
                                style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700,
                                  color: Colors.white, height: 1.1,
                                ),
                              ),
                              if (discountType == 'percentage')
                                Text(
                                  'DISKON',
                                  style: TextStyle(
                                    fontSize: 7, fontWeight: FontWeight.w600,
                                    color: Colors.white70, letterSpacing: 1.2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        CustomPaint(
                          size: const Size(1, double.infinity),
                          painter: DashedLinePainter(),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(AppSizes.md, 8, AppSizes.md, 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: isDark ? 0.20 : 1.0),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        code,
                                        style: TextStyle(
                                          fontSize: 9, fontWeight: FontWeight.w700,
                                          color: isDark ? Colors.white : const Color(0xFFFF4B2B),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  desc,
                                  style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 2 - 10);
    path.arcToPoint(
      Offset(size.width, size.height / 2 + 10),
      radius: const Radius.circular(10),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height / 2 + 10);
    path.arcToPoint(
      Offset(0, size.height / 2 - 10),
      radius: const Radius.circular(10),
      clockwise: false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(128)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    const double dashHeight = 5;
    const double dashSpace = 4;
    double startY = 10;
    while (startY < size.height - 10) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
