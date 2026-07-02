import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/country_codes.dart';
import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final String? scrollToSection;
  const EditProfilePage({super.key, this.scrollToSection});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey            = GlobalKey<FormState>();
  final _scrollController   = ScrollController();

  final _usernameController        = TextEditingController();
  final _emailController           = TextEditingController();
  final _whatsappController        = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _countryCode          = '+62';
  bool   _editing              = false;
  bool   _saving               = false;
  bool   _obscurePassword      = true;
  bool   _obscureConfirmPass   = true;
  File?  _avatarFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFromProfile());
  }

  void _loadFromProfile() {
    final userData = ref.read(profileProvider).userData;
    if (userData == null) return;

    _usernameController.text = userData['username'] as String? ?? '';
    _emailController.text    = userData['email']    as String? ?? '';

    // Parse WhatsApp
    String rawWa = (userData['whatsapp'] as String? ?? '').trim();
    rawWa = rawWa.replaceAll(RegExp(r'[\s\-()]'), ''); // Hapus spasi dan tanda hubung

    if (rawWa.startsWith('+')) {
      bool found = false;
      for (final c in countryCodes) {
        if (rawWa.startsWith(c.dialCode)) {
          _countryCode = c.dialCode;
          _whatsappController.text = rawWa.substring(c.dialCode.length);
          found = true;
          break;
        }
      }
      if (!found) {
        _whatsappController.text = rawWa;
      }
    } else if (rawWa.startsWith('62')) {
      _countryCode = '+62';
      _whatsappController.text = rawWa.substring(2);
    } else if (rawWa.startsWith('0')) {
      _countryCode = '+62';
      _whatsappController.text = rawWa.substring(1);
    } else {
      _countryCode = '+62';
      _whatsappController.text = rawWa;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    if (!_editing) return;
    final action = await showModalBottomSheet<String>(
      context: context,
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () => Navigator.pop(ctx, 'camera'),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () => Navigator.pop(ctx, 'gallery'),
              ),
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('File Manager'),
                onTap: () => Navigator.pop(ctx, 'file'),
              ),
              ListTile(
                leading: const Icon(Icons.cloud),
                title: const Text('Google Drive'),
                onTap: () => Navigator.pop(ctx, 'drive'),
              ),
            ],
          ),
        ),
      ),
    );
    if (action == null) return;

    switch (action) {
      case 'camera':
      case 'gallery':
        final picked = await ImagePicker().pickImage(
          source: action == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 1200, maxHeight: 800,
        );
        if (picked != null) setState(() => _avatarFile = File(picked.path));
        break;
      case 'file':
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null && result.files.single.path != null) {
          setState(() => _avatarFile = File(result.files.single.path!));
        }
        break;
      case 'drive':
        await _pickFromDrive();
    }
  }

  Future<void> _pickFromDrive() async {
    try {
      const scopes = ['email', 'https://www.googleapis.com/auth/drive.readonly'];
      final googleSignIn = GoogleSignIn(scopes: scopes);
      final account = await googleSignIn.signIn();
      if (account == null) return;

      final auth = await account.authentication;
      final token = auth.accessToken;
      if (token == null) return;

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
      if (files.isEmpty || !mounted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada gambar di Google Drive')),
          );
        }
        return;
      }

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
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text('Pilih dari Google Drive',
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
                      leading: const Icon(Icons.image_rounded, size: 40, color: Colors.grey),
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

      if (selected == null || !mounted) return;

      final fileId = selected['id'] as String?;
      final fileName = selected['name'] as String? ?? 'drive_image';
      if (fileId == null) return;

      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/$fileName');
      await dio.download(
        'https://www.googleapis.com/drive/v3/files/$fileId?alt=media',
        tempFile.path,
      );

      if (mounted) {
        setState(() => _avatarFile = tempFile);
      }

      await googleSignIn.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil dari Google Drive: $e')),
        );
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi konfirmasi password jika diisi
    if (_passwordController.text.isNotEmpty) {
      if (_confirmPasswordController.text.isEmpty) {
        AppSnackBar.show(context, 'Konfirmasi kata sandi wajib diisi', type: SnackBarType.error);
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        AppSnackBar.show(context, 'Kata sandi dan konfirmasi tidak cocok', type: SnackBarType.error);
        return;
      }
    }

    setState(() => _saving = true);
    final userData   = ref.read(profileProvider).userData;
    final notifier   = ref.read(profileProvider.notifier);
    final oldEmail   = (userData?['email'] as String? ?? '').toLowerCase();
    final newEmail   = _emailController.text.trim().toLowerCase();
    final emailChanged = newEmail != oldEmail && newEmail.isNotEmpty;

    try {
      // 1. Upload avatar jika dipilih
      String? newAvatarUrl;
      if (_avatarFile != null) {
        newAvatarUrl = await notifier.uploadAvatar(_avatarFile!.path);
      }

      // 2. Update profil (username, whatsapp, email, password)
      final data = <String, dynamic>{
        'username': _usernameController.text.trim(),
        'email':    _emailController.text.trim(),
        'whatsapp': '$_countryCode ${_whatsappController.text.trim()}',
      };
      if (_passwordController.text.isNotEmpty) {
        data['password']              = _passwordController.text;
        data['password_confirmation'] = _confirmPasswordController.text;
      }
      await notifier.updateProfile(data);
      ref.read(authProvider.notifier).refreshUser();
      if (newAvatarUrl != null) {
        ref.read(authProvider.notifier).updateAvatarDirect(newAvatarUrl);
      }

      // 3. Jika email berubah → kirim OTP dan arahkan ke verifikasi
      if (emailChanged) {
        try {
          await DioClient.instance.post(
            '/auth/send-otp',
            data: {'email': newEmail, 'purpose': 'verify_email'},
          );
          if (mounted) {
            AppSnackBar.show(
              context,
              'Profil disimpan. Verifikasi email baru Anda.',
              type: SnackBarType.success,
            );
            context.push('/verify-otp', extra: {'email': newEmail, 'purpose': 'verify_email'});
          }
        } catch (_) {
          if (mounted) {
            AppSnackBar.show(
              context,
              'Profil disimpan. Gagal kirim OTP verifikasi email.',
              type: SnackBarType.warning,
            );
            setState(() { _editing = false; _saving = false; });
          }
        }
      } else {
        if (mounted) {
          AppSnackBar.show(context, 'Profil berhasil diperbarui', type: SnackBarType.success);
          setState(() { _editing = false; _saving = false; });
          _passwordController.clear();
          _confirmPasswordController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, 'Gagal menyimpan profil', type: SnackBarType.error);
        setState(() => _saving = false);
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state    = ref.watch(profileProvider);
    final userData = state.userData;
    final avatarUrl = Formatters.avatarUrl(userData);

    final firstName = userData?['first_name'] as String? ?? '';
    final midName   = userData?['mid_name']   as String? ?? '';
    final lastName  = userData?['last_name']  as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
        actions: [
          if (!_editing)
            TextButton(
              onPressed: () => setState(() => _editing = true),
              child: const Text('Edit'),
            )
          else
            TextButton(
              onPressed: () => setState(() {
                _editing = false;
                _passwordController.clear();
                _confirmPasswordController.clear();
                _loadFromProfile();
              }),
              child: const Text('Batal'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Foto Profil ─────────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: _editing ? _pickAvatar : null,
                  child: Stack(
                    children: [
                      Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 3,
                          ),
                          image: (_avatarFile != null || avatarUrl != null)
                              ? DecorationImage(
                                  image: _avatarFile != null
                                      ? FileImage(_avatarFile!) as ImageProvider
                                      : CachedNetworkImageProvider(Formatters.imageUrl(avatarUrl!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: AppColors.secondaryColor.withAlpha(60),
                        ),
                        child: (_avatarFile == null && avatarUrl == null)
                            ? const Icon(Icons.person, size: 48, color: AppColors.textTertiary)
                            : null,
                      ),
                      if (_editing)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.lg),
              const Divider(),
              const SizedBox(height: AppSizes.sm),

              // ── Nama (READ-ONLY, hanya tampil) ──────────────────────────
              _buildReadOnlySection(
                label: 'Nama Depan',
                value: firstName.isEmpty ? '-' : firstName,
              ),
              const SizedBox(height: AppSizes.sm),
              _buildReadOnlySection(
                label: 'Nama Tengah',
                value: midName.isEmpty ? '-' : midName,
              ),
              const SizedBox(height: AppSizes.sm),
              _buildReadOnlySection(
                label: 'Nama Belakang',
                value: lastName.isEmpty ? '-' : lastName,
              ),

              const SizedBox(height: AppSizes.md),
              const Divider(),
              const SizedBox(height: AppSizes.sm),

              // ── Username ─────────────────────────────────────────────────
              AppTextField(
                label: 'Username',
                controller: _usernameController,
                readOnly: !_editing,
                validator: _editing ? Validators.required : null,
              ),
              const SizedBox(height: AppSizes.sm),

              // ── Email ────────────────────────────────────────────────────
              AppTextField(
                label: 'Email',
                controller: _emailController,
                readOnly: !_editing,
                keyboardType: TextInputType.emailAddress,
                validator: _editing ? Validators.email : null,
              ),
              if (_editing) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 13, color: Colors.orange),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Jika email diubah, Anda perlu verifikasi OTP',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.orange.shade700),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSizes.sm),

              // ── WhatsApp ─────────────────────────────────────────────────
              _editing
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final code = await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => _CountryCodeSheet(selectedCode: _countryCode),
                            );
                            if (code != null) setState(() => _countryCode = code);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.dividerColor),
                            ),
                            child: Row(
                              children: [
                                Text(_countryCode, style: AppTextStyles.bodyMedium),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down, size: 18, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _whatsappController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: Validators.phone,
                            style: AppTextStyles.bodyLarge,
                            decoration: const InputDecoration(),
                          ),
                        ),
                      ],
                    )
                  : _buildReadOnlySection(
                      label: 'WhatsApp',
                      value: _whatsappController.text.isEmpty
                          ? '-'
                          : '$_countryCode ${_whatsappController.text}',
                    ),

              // ── Password (hanya tampil di view mode sebagai ●●●●●●) ────
              if (!_editing) ...[
                const SizedBox(height: AppSizes.sm),
                _buildReadOnlySection(
                  label: 'Kata Sandi',
                  value: '●●●●●●●●',
                ),
              ],

              // ── Password + Confirm (hanya saat edit) ─────────────────────
              if (_editing) ...[
                const SizedBox(height: AppSizes.sm),
                AppTextField(
                  label: 'Kata Sandi Baru (kosongkan jika tidak diubah)',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v != null && v.isNotEmpty && v.length < 8) {
                      return 'Kata sandi minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.sm),
                AppTextField(
                  label: 'Konfirmasi Kata Sandi Baru',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPass,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPass ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPass = !_obscureConfirmPass),
                  ),
                  validator: (v) {
                    if (_passwordController.text.isNotEmpty) {
                      if (v == null || v.isEmpty) return 'Konfirmasi kata sandi wajib diisi';
                      if (v != _passwordController.text) return 'Kata sandi tidak cocok';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: AppSizes.xl),

              // ── Tombol Simpan (hanya saat edit) ──────────────────────────
              if (_editing)
                AppButton(
                  label: 'Simpan Perubahan',
                  loading: _saving,
                  onPressed: _save,
                  type: ButtonType.primary,
                ),

              const SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }

  // ── Read-only display row ─────────────────────────────────────────────────
  Widget _buildReadOnlySection({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: value == '-' ? AppColors.textTertiary : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Country Code Bottom Sheet ─────────────────────────────────────────────────

class _CountryCodeSheet extends StatelessWidget {
  final String selectedCode;
  const _CountryCodeSheet({required this.selectedCode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          Text('Pilih Kode Negara', style: AppTextStyles.titleSmall),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: countryCodes.length,
              itemBuilder: (_, i) {
                final c = countryCodes[i];
                final isSelected = c.dialCode == selectedCode;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(
                    '${c.name} (${c.dialCode})',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primaryColor)
                      : null,
                  onTap: () => Navigator.pop(context, c.dialCode),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
