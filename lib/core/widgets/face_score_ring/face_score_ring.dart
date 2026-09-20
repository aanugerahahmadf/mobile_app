import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mobile_app/core/constants/app_colors/app_colors.dart';

/// Memetakan kotak wajah hasil ML Kit (koordinat citra tegak) ke koordinat
/// layar sesuai tampilan `CameraPreview` (BoxFit.cover + mirror kamera depan).
Rect? faceBoxToScreen({
  required Rect box,
  required Size frameSize,
  required Size target,
  required bool mirrorX,
}) {
  if (frameSize.width <= 0 || frameSize.height <= 0) return null;

  final scale = math.max(target.width / frameSize.width, target.height / frameSize.height);
  final displayW = frameSize.width * scale;
  final displayH = frameSize.height * scale;
  final offsetX = (target.width - displayW) / 2;
  final offsetY = (target.height - displayH) / 2;

  double left = offsetX + box.left * scale;
  double top = offsetY + box.top * scale;
  double right = offsetX + box.right * scale;
  double bottom = offsetY + box.bottom * scale;

  // Kamera depan dicerminkan di preview, sedangkan koordinat ML Kit tidak.
  if (mirrorX) {
    final mirroredLeft = target.width - right;
    right = target.width - left;
    left = mirroredLeft;
  }

  return Rect.fromLTRB(left, top, right, bottom);
}

/// Menggambar lingkaran bulat mengelilingi wajah beserta **ring skor** di
/// sekelilingnya. [score] 0..1, [ready] hijau saat siap.
void paintFaceScoreRing(Canvas canvas, Rect faceRect, double score, bool ready) {
  final color = ready ? AppColors.successColor : Colors.white;
  final center = faceRect.center;
  final radius = faceRect.shortestSide / 2;

  // Lingkaran wajah (bingkai bulat-bulat).
  final facePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..color = color;
  canvas.drawCircle(center, radius, facePaint);

  // Lintasan ring.
  final trackPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..color = Colors.white24;
  canvas.drawCircle(center, radius + 8, trackPaint);

  // Ring skor (progress searah jarum jam, mulai dari atas).
  final arcPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round
    ..color = color;
  final ringRect = Rect.fromCircle(center: center, radius: radius + 8);
  canvas.drawArc(ringRect, -math.pi / 2, 2 * math.pi * score.clamp(0.0, 1.0), false, arcPaint);

  // Label persentase di atas lingkaran.
  final percent = (score.clamp(0.0, 1.0) * 100).round();
  final textPainter = TextPainter(
    text: TextSpan(
      text: '$percent%',
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        shadows: const [Shadow(color: Colors.black, blurRadius: 8)],
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(
    canvas,
    Offset(center.dx - textPainter.width / 2, center.dy - radius - 8 - textPainter.height - 4),
  );
}
