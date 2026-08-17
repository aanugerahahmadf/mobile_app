import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../constants/app_colors.dart';
import '../errors/localized_error.dart';

/// Menampilkan bottom sheet untuk memilih foto/video profil tanpa scanner.
/// Mendukung kamera foto, kamera video, galeri (gambar & video), dan file
/// manager (gambar & video). Jika [showDrive] true, tambahan pilihan Google
/// Drive (khusus gambar).
Future<File?> pickProfileMedia(
  BuildContext context, {
  bool showDrive = false,
}) async {
  final l = AppLocalizations.of(context)!;
  final action = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l.takePhoto),
              onTap: () => Navigator.pop(ctx, 'camera_photo'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l.takeVideo),
              onTap: () => Navigator.pop(ctx, 'camera_video'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l.gallery),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: Text(l.fileManager),
              onTap: () => Navigator.pop(ctx, 'file'),
            ),
            if (showDrive)
              ListTile(
                leading: const Icon(Icons.cloud),
                title: Text(l.googleDrive),
                onTap: () => Navigator.pop(ctx, 'drive'),
              ),
          ],
        ),
      ),
    ),
  );
  if (action == null) return null;
  if (!context.mounted) return null;

  switch (action) {
    case 'camera_photo':
      final picked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 800,
      );
      return picked != null ? File(picked.path) : null;
    case 'camera_video':
      final picked = await ImagePicker().pickVideo(source: ImageSource.camera);
      return picked != null ? File(picked.path) : null;
    case 'gallery':
      final picked = await ImagePicker().pickMedia();
      return picked != null ? File(picked.path) : null;
    case 'file':
      final result = await FilePicker.platform.pickFiles(type: FileType.media);
      final path = result?.files.single.path;
      return path != null ? File(path) : null;
    case 'drive':
      return _pickFromDrive(context);
  }
  return null;
}

Future<File?> _pickFromDrive(BuildContext context) async {
  final l = AppLocalizations.of(context)!;
  try {
    const scopes = ['email', 'https://www.googleapis.com/auth/drive.readonly'];
    final googleSignIn = GoogleSignIn(scopes: scopes);
    final account = await googleSignIn.signIn();
    if (account == null) return null;

    final auth = await account.authentication;
    final token = auth.accessToken;
    if (token == null) return null;

    final dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer $token'},
    ));

    final response = await dio.get(
      'https://www.googleapis.com/drive/v3/files',
      queryParameters: {
        'q': "mimeType contains 'image/' and trashed = false",
        'fields': 'files(id, name, mimeType, webContentLink, size)',
        'orderBy': 'modifiedTime desc',
        'pageSize': 20,
      },
    );

    final files = (response.data['files'] as List?) ?? [];
    if (files.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.noImagesInGoogleDrive)),
        );
      }
      return null;
    }

    if (!context.mounted) return null;

    final selected = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4, margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(l.pickFromGoogleDrive,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.45,
              child: ListView.separated(
                itemCount: files.length,
                separatorBuilder: (_, _) => const Divider(height: 1, indent: 70),
                itemBuilder: (_, i) {
                  final file = files[i];
                  return ListTile(
                    leading: Icon(Icons.image_rounded, size: 40, color: AppColors.textTertiary),
                    title: Text(file['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.pop(ctx, file as Map<String, dynamic>),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selected == null) return null;

    final fileId = selected['id'] as String?;
    final fileName = selected['name'] as String? ?? 'drive_image';
    if (fileId == null) return null;

    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/$fileName');
    await dio.download(
      'https://www.googleapis.com/drive/v3/files/$fileId?alt=media',
      tempFile.path,
    );

    await googleSignIn.signOut();
    return tempFile;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizedError.of(l, e.toString()))),
      );
    }
    return null;
  }
}
