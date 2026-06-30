import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class VoucherCard extends StatelessWidget {
  final Map<String, dynamic> voucher;
  final VoidCallback? onTap;

  const VoucherCard({super.key, required this.voucher, this.onTap});

  @override
  Widget build(BuildContext context) {
    final code = voucher['code'] as String? ?? 'PROMO';
    final desc = voucher['description'] as String? ?? 'Diskon menarik untuk Anda';
    final discountRaw = voucher['discount_amount'] ?? voucher['discount'] ?? 0;
    final discountType = voucher['discount_type'] as String? ?? 'percentage';

    // Format diskon besar
    String discLabel = '';
    if (discountType == 'percentage') {
      final double val = discountRaw is num ? discountRaw.toDouble() : (double.tryParse(discountRaw.toString()) ?? 0.0);
      discLabel = '${val.toInt()}%';
    } else {
      final int val = discountRaw is num ? discountRaw.toInt() : (double.tryParse(discountRaw.toString())?.toInt() ?? 0);
      if (val >= 1000) {
        discLabel = '${val ~/ 1000}k';
      } else {
        discLabel = '$val';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 124,
          child: ClipPath(
        clipper: TicketClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF416C), // Pink-red gradient mewah
                Color(0xFFFF4B2B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4B2B).withAlpha(100),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Hiasan lingkaran background transparan
              Positioned(
                right: -20,
                top: -20,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withAlpha(25),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -30,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withAlpha(15),
                ),
              ),

              // Konten Utama
              Row(
                children: [
                  // Sisi Kiri: Nilai Diskon
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (discountType == 'fixed')
                          Text(
                            'POTONGAN',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withAlpha(204),
                              letterSpacing: 1.0,
                            ),
                          ),
                        Text(
                          discLabel,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        if (discountType == 'percentage')
                          const Text(
                            'DISKON',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white70,
                              letterSpacing: 1.2,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Garis Putus-Putus Vertikal (Dashed Line)
                  CustomPaint(
                    size: const Size(1, double.infinity),
                    painter: DashedLinePainter(),
                  ),

                  // Sisi Kanan: Detail & Kode Voucher
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              code,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4B2B),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            desc,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ketuk untuk salin atau gunakan',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white.withAlpha(179),
                              fontStyle: FontStyle.italic,
                            ),
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
    );
  }
}

// Clipper untuk membentuk sobekan tiket kiri dan kanan
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);

    // Garis atas dengan sobekan kecil
    path.lineTo(size.width, 0);
    
    // Potongan kanan
    path.lineTo(size.width, size.height / 2 - 10);
    path.arcToPoint(
      Offset(size.width, size.height / 2 + 10),
      radius: const Radius.circular(10),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);

    // Garis bawah
    path.lineTo(0, size.height);

    // Potongan kiri
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

// Pelukis garis putus-putus vertikal
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
