import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Core/Widgets/CameraCoverPreview/CameraCoverPreview.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/AutoCaptureScanner/AutoCaptureScannerScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/DocumentScanner/DocumentScannerScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/FaceScanner/FaceScannerScreen.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

/// Kamera palsu supaya layar scanner bisa dirender tanpa perangkat fisik.
class _FakeCameraPlatform extends CameraPlatform {
  final StreamController<CameraErrorEvent> _errors =
      StreamController<CameraErrorEvent>.broadcast();
  final StreamController<DeviceOrientationChangedEvent> _orientations =
      StreamController<DeviceOrientationChangedEvent>.broadcast();
  final StreamController<CameraImageData> _frames =
      StreamController<CameraImageData>.broadcast();

  static const CameraDescription frontCamera = CameraDescription(
    name: 'fake-front',
    lensDirection: CameraLensDirection.front,
    sensorOrientation: 270,
  );

  @override
  Future<List<CameraDescription>> availableCameras() async =>
      const <CameraDescription>[frontCamera];

  @override
  Future<int> createCamera(
    CameraDescription cameraDescription,
    ResolutionPreset? resolutionPreset, {
    bool enableAudio = false,
  }) async => 1;

  @override
  Future<void> initializeCamera(
    int cameraId, {
    ImageFormatGroup imageFormatGroup = ImageFormatGroup.unknown,
  }) async {}

  @override
  Stream<CameraInitializedEvent> onCameraInitialized(int cameraId) =>
      Stream<CameraInitializedEvent>.value(
        CameraInitializedEvent(
          cameraId,
          1280,
          720,
          ExposureMode.auto,
          true,
          FocusMode.auto,
          true,
        ),
      );

  @override
  Stream<CameraErrorEvent> onCameraError(int cameraId) => _errors.stream;

  @override
  Stream<DeviceOrientationChangedEvent> onDeviceOrientationChanged() =>
      _orientations.stream;

  @override
  Stream<CameraImageData> onStreamedFrameAvailable(
    int cameraId, {
    CameraImageStreamOptions? options,
  }) => _frames.stream;

  @override
  bool supportsImageStreaming() => true;

  @override
  Future<void> setFocusMode(int cameraId, FocusMode mode) async {}

  @override
  Widget buildPreview(int cameraId) => const ColoredBox(
    key: ValueKey<String>('fake-camera-preview'),
    color: Colors.black,
  );

  @override
  Future<void> dispose(int cameraId) async {}
}

const List<Size> _surfaceSizes = <Size>[
  Size(360, 640),
  Size(400, 844),
  Size(800, 400), // landscape
];

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

Future<void> _pumpScanner(
  WidgetTester tester,
  Widget screen,
  Size logicalSize,
) async {
  tester.view.physicalSize = logicalSize;
  tester.view.devicePixelRatio = 1.0;
  tester.view.padding = const FakeViewPadding(top: 24, bottom: 34);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(_wrap(screen));
  await tester.pumpAndSettle();
}

CustomPaint _overlayPaint(WidgetTester tester, String painterTypeName) {
  final paints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
  return paints.firstWhere(
    (paint) => paint.painter?.runtimeType.toString() == painterTypeName,
    orElse: () => throw StateError(
      'Overlay painter $painterTypeName tidak ditemukan di pohon widget.',
    ),
  );
}

void _expectRectInside(Rect rect, Size area, String label) {
  expect(rect.width, greaterThan(1), reason: '$label harus punya lebar');
  expect(rect.height, greaterThan(1), reason: '$label harus punya tinggi');
  expect(rect.left, greaterThanOrEqualTo(0.0), reason: '$label keluar kiri');
  expect(rect.top, greaterThanOrEqualTo(0.0), reason: '$label keluar atas');
  expect(
    rect.right,
    lessThanOrEqualTo(area.width),
    reason: '$label keluar kanan',
  );
  expect(
    rect.bottom,
    lessThanOrEqualTo(area.height),
    reason: '$label keluar bawah',
  );
}

/// Preview kamera dan overlay harus menempati area yang sama, sehingga
/// koordinat hasil deteksi (faceBoxToScreen) tidak bergeser dari gambar.
void _expectCoverPreviewAlignsWithOverlay(
  WidgetTester tester,
  CustomPaint overlay,
) {
  final cover = find.byType(CameraCoverPreview);
  expect(cover, findsOneWidget);

  final fitted = find.descendant(of: cover, matching: find.byType(FittedBox));
  expect(fitted, findsWidgets);
  expect(tester.widget<FittedBox>(fitted.first).fit, BoxFit.cover);

  final coverClip = find.descendant(of: cover, matching: find.byType(ClipRect));
  expect(coverClip, findsWidgets);
  final coverSize = tester.getSize(coverClip.first);
  final overlaySize = tester.getSize(find.byWidget(overlay));
  expect(coverSize.width, moreOrLessEquals(overlaySize.width, epsilon: 0.5));
  expect(coverSize.height, moreOrLessEquals(overlaySize.height, epsilon: 0.5));

  // previewSize 1280x720 pada orientasi portrait -> kotak 720x1280.
  final boxes = tester.widgetList<SizedBox>(
    find.descendant(of: cover, matching: find.byType(SizedBox)),
  );
  expect(
    boxes.any((box) => box.width == 720 && box.height == 1280),
    isTrue,
    reason: 'Rasio preview portrait harus mengikuti ukuran sensor.',
  );
}

/// Painter tidak boleh melempar exception saat menerima ukuran ekstrem
/// (mis. layar hampir nol karena transisi layout).
void _expectPainterSurvivesTinyCanvas(CustomPainter painter, Size realSize) {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  expect(() => painter.paint(canvas, realSize), returnsNormally);
  expect(() => painter.paint(canvas, Size.zero), returnsNormally);
  expect(() => painter.paint(canvas, const Size(1, 1)), returnsNormally);
  recorder.endRecording().dispose();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestDefaultBinaryMessenger messenger;

  setUp(() {
    CameraPlatform.instance = _FakeCameraPlatform();
    messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (MethodCall call) async => 1,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('google_mlkit_face_detector'),
      (MethodCall call) async => null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('google_mlkit_text_recognizer'),
      (MethodCall call) async => null,
    );
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('google_mlkit_face_detector'),
      null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('google_mlkit_text_recognizer'),
      null,
    );
  });

  group('FaceScanner overlay', () {
    for (final size in _surfaceSizes) {
      testWidgets(
        'oval stays inside the camera area ${size.width}x${size.height}',
        (tester) async {
          await _pumpScanner(tester, const FaceScannerScreen(), size);

          expect(
            find.byKey(const ValueKey<String>('fake-camera-preview')),
            findsOneWidget,
          );

          final overlay = _overlayPaint(tester, '_FaceOvalPainter');
          final overlaySize = tester.getSize(find.byWidget(overlay));
          final dynamic painter = overlay.painter;
          final Rect ovalRect = painter.faceRect as Rect;

          _expectRectInside(ovalRect, overlaySize, 'Oval wajah');

          // Oval tidak boleh menabrak kartu instruksi di bagian bawah.
          final overlayTopLeft = tester.getTopLeft(find.byWidget(overlay));
          final cardRect = tester.getRect(
            find.byKey(const ValueKey<String>('face-instruction-card')),
          );
          expect(
            ovalRect.shift(overlayTopLeft).bottom,
            lessThanOrEqualTo(cardRect.top + 0.5),
            reason: 'Oval wajah tidak boleh menimpa kartu instruksi.',
          );

          _expectCoverPreviewAlignsWithOverlay(tester, overlay);
          _expectPainterSurvivesTinyCanvas(overlay.painter!, overlaySize);
        },
      );
    }
  });

  group('DocumentScanner overlay', () {
    for (final docType in const ['ktp', 'sim', 'npwp', 'passport']) {
      for (final size in _surfaceSizes) {
        testWidgets(
          'document frame stays inside the camera area for $docType ${size.width}x${size.height}',
          (tester) async {
            await _pumpScanner(
              tester,
              DocumentScannerScreen(docType: docType),
              size,
            );

            expect(
              find.byKey(const ValueKey<String>('fake-camera-preview')),
              findsOneWidget,
            );

            final overlay = _overlayPaint(tester, '_DocumentOverlayPainter');
            final overlaySize = tester.getSize(find.byWidget(overlay));
            final dynamic painter = overlay.painter;
            final Rect frameRect = painter.frameRect as Rect;

            _expectRectInside(frameRect, overlaySize, 'Bingkai dokumen');

            // Bingkai tidak boleh menimpa pill instruksi maupun tombol rana.
            final overlayTopLeft = tester.getTopLeft(find.byWidget(overlay));
            final frameGlobal = frameRect.shift(overlayTopLeft);
            final instructionRect = tester.getRect(
              find.byKey(const ValueKey<String>('document-scan-instruction')),
            );
            final captureRect = tester.getRect(
              find.byKey(const ValueKey<String>('document-capture-button')),
            );
            expect(
              frameGlobal.bottom,
              lessThanOrEqualTo(instructionRect.top + 0.5),
              reason: 'Bingkai dokumen tidak boleh menimpa instruksi.',
            );
            expect(
              frameGlobal.bottom,
              lessThanOrEqualTo(captureRect.top + 0.5),
              reason: 'Bingkai dokumen tidak boleh menimpa tombol rana.',
            );

            // Paspor berbentuk portrait; KTP/SIM/NPWP berbentuk kartu landscape.
            if (docType == 'passport') {
              expect(
                frameRect.height,
                greaterThan(frameRect.width),
                reason: 'Bingkai paspor harus portrait.',
              );
            } else {
              expect(
                frameRect.width,
                greaterThan(frameRect.height),
                reason: 'Bingkai $docType harus landscape.',
              );
            }

            _expectCoverPreviewAlignsWithOverlay(tester, overlay);
            _expectPainterSurvivesTinyCanvas(overlay.painter!, overlaySize);
          },
        );
      }
    }
  });

  group('AutoCaptureScanner overlay', () {
    for (final size in _surfaceSizes) {
      testWidgets(
        'auto scan frame stays inside the camera area ${size.width}x${size.height}',
        (tester) async {
          await _pumpScanner(tester, const AutoCaptureScannerScreen(), size);

          expect(
            find.byKey(const ValueKey<String>('fake-camera-preview')),
            findsOneWidget,
          );

          final overlay = _overlayPaint(tester, '_AutoScanOverlayPainter');
          final overlaySize = tester.getSize(find.byWidget(overlay));
          final dynamic painter = overlay.painter;
          final Rect frameRect = painter.frameRect as Rect;

          _expectRectInside(frameRect, overlaySize, 'Bingkai auto scan');
          _expectCoverPreviewAlignsWithOverlay(tester, overlay);
          _expectPainterSurvivesTinyCanvas(overlay.painter!, overlaySize);
        },
      );
    }
  });

  group('Face and document scans are separate screens', () {
    for (final size in _surfaceSizes) {
      testWidgets(
        'face screen only paints a face oval ${size.width}x${size.height}',
        (tester) async {
          await _pumpScanner(tester, const FaceScannerScreen(), size);

          final paints = tester.widgetList<CustomPaint>(
            find.byType(CustomPaint),
          );
          final painters = paints
              .map((p) => p.painter?.runtimeType.toString())
              .whereType<String>();
          expect(painters, contains('_FaceOvalPainter'));
          expect(painters, isNot(contains('_DocumentOverlayPainter')));
        },
      );

      testWidgets(
        'document screen only paints a document frame ${size.width}x${size.height}',
        (tester) async {
          await _pumpScanner(
            tester,
            const DocumentScannerScreen(docType: 'passport'),
            size,
          );

          final paints = tester.widgetList<CustomPaint>(
            find.byType(CustomPaint),
          );
          final painters = paints
              .map((p) => p.painter?.runtimeType.toString())
              .whereType<String>();
          expect(painters, contains('_DocumentOverlayPainter'));
          expect(painters, isNot(contains('_FaceOvalPainter')));
        },
      );
    }
  });
}
