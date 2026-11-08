import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Menampilkan [CameraPreview] dengan mode **BoxFit.cover** agar gambar
/// kamera selalu memenuhi seluruh area scanner tanpa letterbox.
///
/// `CameraPreview` bawaan memakai `AspectRatio`, sehingga pada layar tinggi
/// masih menyisakan area hitam di bawah. Padahal pemetaan kotak deteksi
/// (`faceBoxToScreen`) memakai perhitungan `BoxFit.cover`. Dengan menyamakan
/// cara render preview dan cara memetakan deteksi, garis panduan (oval wajah
/// dan bingkai dokumen) tetap menempel pada objek yang terlihat di kamera.
class CameraCoverPreview extends StatelessWidget {
  const CameraCoverPreview(this.controller, {super.key});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final preview = controller.value.previewSize;
    if (preview == null || preview.width <= 0 || preview.height <= 0) {
      return CameraPreview(controller);
    }

    // Samakan sumber orientasi dengan yang dipakai `CameraPreview` agar
    // rasio kotak preview tidak pernah berbeda dengan rasio yang digambar.
    // `previewSize` mengikuti orientasi sensor (umumnya landscape), jadi
    // dimensinya ditukar saat perangkat portrait.
    final orientation = controller.value.deviceOrientation;
    final isLandscape =
        orientation == DeviceOrientation.landscapeLeft ||
        orientation == DeviceOrientation.landscapeRight;
    final width = isLandscape ? preview.width : preview.height;
    final height = isLandscape ? preview.height : preview.width;

    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: width,
            height: height,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}
