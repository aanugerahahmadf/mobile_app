import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';

enum FormFieldType { text, multiline, number, image, dropdown, toggle, email, password }

class FormFieldConfig {
  final String key;
  final String label;
  final bool required;
  final FormFieldType type;
  final List<String>? options;
  final String? endpoint;
  final String? endpointQuery;
  final String valueKey;
  final String labelKey;
  final Widget? prefix;

  const FormFieldConfig({
    required this.key,
    required this.label,
    this.required = false,
    this.type = FormFieldType.text,
    this.options,
    this.endpoint,
    this.endpointQuery,
    this.valueKey = 'id',
    this.labelKey = 'name',
    this.prefix,
  });
}

class AdminFormDialog extends StatefulWidget {
  final String title;
  final List<FormFieldConfig> fields;
  final Map<String, dynamic>? initialData;
  final Map<String, List<Map<String, dynamic>>> preloadedOptions;

  const AdminFormDialog({
    super.key,
    required this.title,
    required this.fields,
    this.initialData,
    this.preloadedOptions = const {},
  });

  @override
  State<AdminFormDialog> createState() => _AdminFormDialogState();
}

class _AdminFormDialogState extends State<AdminFormDialog> {
  late Map<String, TextEditingController> _controllers;
  final Map<String, String?> _imagePaths = {};
  final Map<String, bool> _toggleValues = {};
  final Map<String, String?> _dropdownValues = {};

  @override
  void initState() {
    super.initState();
    _controllers = {};
    for (final f in widget.fields) {
      if (f.type == FormFieldType.image) {
        _imagePaths[f.key] = widget.initialData?[f.key]?.toString();
      } else if (f.type == FormFieldType.toggle) {
        _toggleValues[f.key] = widget.initialData?[f.key] == true || widget.initialData?[f.key] == 1 || widget.initialData?[f.key] == '1';
      } else if (f.type == FormFieldType.dropdown) {
        final current = widget.initialData?[f.key]?.toString() ?? '';
        _dropdownValues[f.key] = current;
      } else {
        _controllers[f.key] = TextEditingController(
          text: widget.initialData?[f.key]?.toString() ?? '',
        );
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(String key) async {
    final source = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(ctx)!.chooseSource, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(ctx)!.camera),
                onTap: () => Navigator.pop(ctx, 0),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(ctx)!.gallery),
                onTap: () => Navigator.pop(ctx, 1),
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: Text(AppLocalizations.of(ctx)!.fileManager),
                onTap: () => Navigator.pop(ctx, 2),
              ),
              ListTile(
                leading: const Icon(Icons.cloud),
                title: Text(AppLocalizations.of(ctx)!.googleDrive),
                onTap: () => Navigator.pop(ctx, 3),
              ),
            ],
          ),
        ),
      ),
    );
    if (source != null) {
      String? path;
      if (source == 0 || source == 1) {
        final imgSource = source == 0 ? ImageSource.camera : ImageSource.gallery;
        final picked = await ImagePicker().pickImage(source: imgSource, maxWidth: 1024);
        path = picked?.path;
      } else if (source == 2) {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        path = result?.files.single.path;
      } else if (source == 3) {
        path = await _pickFromDrive();
      }
      if (path != null) {
        setState(() => _imagePaths[key] = path);
      }
    }
  }

  Future<String?> _pickFromDrive() async {
    try {
      final googleUser = await GoogleSignIn(
        serverClientId: dotenv.get('GOOGLE_CLIENT_ID'),
        scopes: ['https://www.googleapis.com/auth/drive.readonly'],
      ).signIn();
      if (googleUser == null) return null;

      final auth = await googleUser.authentication;
      if (auth.accessToken == null) return null;

      final response = await Dio().get(
        'https://www.googleapis.com/drive/v3/files',
        queryParameters: {
          'q': "mimeType contains 'image/' and trashed = false",
          'fields': 'files(id, name, mimeType, thumbnailLink)',
          'pageSize': '50',
          'orderBy': 'modifiedTime desc',
        },
        options: Options(headers: {'Authorization': 'Bearer ${auth.accessToken}'}),
      );

      final files = (response.data['files'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (files.isEmpty) return null;
      if (!mounted) return null;

      final selected = await showModalBottomSheet<String>(
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
                child: Text(AppLocalizations.of(ctx)!.pickFromGoogleDrive,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.45,
                child: ListView.separated(
                  itemCount: files.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (_, i) {
                    final f = files[i];
                    final thumb = f['thumbnailLink'] as String?;
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: thumb != null
                            ? CachedNetworkImage(imageUrl: thumb, width: 48, height: 48, fit: BoxFit.cover)
                            : Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.cloud, color: Color(0xFF4CAF50), size: 24),
                              ),
                      ),
                      title: Text(f['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.pop(ctx, f['id'] as String?),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

      if (selected == null) return null;

      final imageResponse = await Dio().get(
        'https://www.googleapis.com/drive/v3/files/$selected?alt=media',
        options: Options(
          headers: {'Authorization': 'Bearer ${auth.accessToken}'},
          responseType: ResponseType.bytes,
        ),
      );

      final tempDir = await Directory.systemTemp.createTemp('drive_');
      final file = File('${tempDir.path}/drive_image.jpg');
      await file.writeAsBytes(imageResponse.data as List<int>);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _collectData() {
    final data = <String, dynamic>{};
    for (final f in widget.fields) {
      switch (f.type) {
        case FormFieldType.image:
          if (_imagePaths[f.key] != null) {
            data[f.key] = _imagePaths[f.key];
          }
        case FormFieldType.toggle:
          data[f.key] = _toggleValues[f.key] ?? false;
        case FormFieldType.dropdown:
          data[f.key] = _dropdownValues[f.key] ?? '';
        case FormFieldType.number:
          data[f.key] = _controllers[f.key]?.text ?? '';
        default:
          data[f.key] = _controllers[f.key]?.text ?? '';
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.title, style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: widget.fields.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildField(f),
                  )).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.pop(context, _collectData()),
                  child: Text(l.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(FormFieldConfig f) {
    switch (f.type) {
      case FormFieldType.image:
        return _buildImageField(f);
      case FormFieldType.toggle:
        return _buildToggleField(f);
      case FormFieldType.dropdown:
        return _buildDropdownField(f);
      case FormFieldType.multiline:
        return TextField(
          controller: _controllers[f.key],
          decoration: InputDecoration(
            labelText: f.label,
            prefixIcon: f.prefix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          maxLines: 3,
        );
      case FormFieldType.number:
        return TextField(
          controller: _controllers[f.key],
          decoration: InputDecoration(
            labelText: f.label,
            prefixIcon: f.prefix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.number,
        );
      case FormFieldType.email:
        return TextField(
          controller: _controllers[f.key],
          decoration: InputDecoration(
            labelText: f.label,
            prefixIcon: f.prefix ?? const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.emailAddress,
        );
      case FormFieldType.password:
        return TextField(
          controller: _controllers[f.key],
          decoration: InputDecoration(
            labelText: f.label,
            prefixIcon: f.prefix ?? const Icon(Icons.lock_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          obscureText: true,
        );
      default:
        return TextField(
          controller: _controllers[f.key],
          decoration: InputDecoration(
            labelText: f.label,
            prefixIcon: f.prefix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  Widget _buildImageField(FormFieldConfig f) {
    final path = _imagePaths[f.key];
    final hasImage = path != null && path.isNotEmpty;
    return InkWell(
      onTap: () => _pickImage(f.key),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: hasImage
                  ? (path.startsWith('http')
                      ? Image.network(path, width: 56, height: 56, fit: BoxFit.cover)
                      : Image.file(File(path), width: 56, height: 56, fit: BoxFit.cover))
                  : Container(
                      width: 56, height: 56,
                      color: AppColors.primaryColor.withAlpha(25),
                      child: Icon(Icons.image_outlined, color: AppColors.primaryColor.withAlpha(150)),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.label, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    hasImage ? path.split('/').last : AppLocalizations.of(context)!.tapToSelectImage,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleField(FormFieldConfig f) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(f.label, style: AppTextStyles.bodyMedium)),
          Switch(
            value: _toggleValues[f.key] ?? false,
            onChanged: (v) => setState(() => _toggleValues[f.key] = v),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(FormFieldConfig f) {
    List<DropdownMenuItem<String>> items;
    String? initialValue;
    final value = _dropdownValues[f.key];

    if (f.endpoint != null) {
      final apiItems = widget.preloadedOptions[f.key] ?? [];
      initialValue = apiItems.any((e) => '${e[f.valueKey]}' == value) ? value : null;
      items = apiItems.map((e) => DropdownMenuItem(
        value: '${e[f.valueKey]}',
        child: Text('${e[f.labelKey] ?? '-'}'),
      )).toList();
    } else {
      final opts = f.options ?? [];
      initialValue = opts.contains(value) ? value : null;
      items = opts.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList();
    }

    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: f.label,
        prefixIcon: f.prefix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items,
      onChanged: (v) => setState(() => _dropdownValues[f.key] = v),
    );
  }
}
