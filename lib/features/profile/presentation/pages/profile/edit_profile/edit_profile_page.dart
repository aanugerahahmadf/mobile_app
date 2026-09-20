import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../core/utils/formatters/formatters.dart';
import '../../../../../../core/utils/profile_media_picker/profile_media_picker.dart';
import '../../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../../core/widgets/app_text_field/app_text_field.dart';
import '../../../../../../core/widgets/app_snackbar/app_snackbar.dart';
import '../../../../../../core/widgets/media_viewer/media_viewer.dart';
import '../../../../../../core/widgets/whatsapp_otp_verifier/whatsapp_otp_verifier.dart';
import '../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../../core/utils/validators/validators.dart';
import '../../../../../../core/utils/country_codes/country_codes.dart';
import '../../../providers/profile_provider/profile_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final String? scrollToSection;
  const EditProfilePage({super.key, this.scrollToSection});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _firstNameController = TextEditingController();
  final _midNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _whatsappController = TextEditingController();

  String _countryCode = '+62';
  bool _editing = false;
  bool _saving = false;
  bool _whatsappVerified = false;
  String _initialWhatsapp = '';
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider) is AuthAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadFromProfile());
    }
  }

  void _loadFromProfile() {
    final userData = ref.read(profileProvider).userData;
    if (userData != null) {
      _firstNameController.text = userData['first_name'] as String? ?? '';
      _midNameController.text = userData['mid_name'] as String? ?? '';
      _lastNameController.text = userData['last_name'] as String? ?? '';
      _usernameController.text = userData['username'] as String? ?? '';
    }

    // Parse WhatsApp
    String rawWa = (userData?['whatsapp'] as String? ?? '').trim();
    _initialWhatsapp = rawWa;
    _whatsappVerified = rawWa.isNotEmpty;
    rawWa = rawWa.replaceAll(
      RegExp(r'[\s\-()]'),
      '',
    ); // Hapus spasi dan tanda hubung

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
    _firstNameController.dispose();
    _midNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _whatsappController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    if (!_editing) return;
    final file = await pickProfileMedia(context, showDrive: true);
    if (file != null) setState(() => _avatarFile = file);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    // WhatsApp harus diverifikasi bila nomor berubah sebelum disimpan
    if (_whatsappController.text.trim().isNotEmpty && !_whatsappVerified) {
      AppSnackBar.show(
        context,
        l.whatsappVerifyRequired,
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => _saving = true);

    try {
      // 1. Upload avatar jika dipilih
      String? newAvatarUrl;
      if (_avatarFile != null) {
        newAvatarUrl = await ref
            .read(profileProvider.notifier)
            .uploadAvatar(_avatarFile!.path);
      }

      // 2. Update profil (first_name, mid_name, last_name, username, whatsapp)
      final data = <String, dynamic>{
        'first_name': _firstNameController.text.trim(),
        'mid_name': _midNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'username': _usernameController.text.trim(),
        'whatsapp': '$_countryCode ${_whatsappController.text.trim()}',
      };
      await ref.read(profileProvider.notifier).updateProfile(data);
      ref.read(authProvider.notifier).refreshUser();
      if (newAvatarUrl != null) {
        ref.read(authProvider.notifier).updateAvatarDirect(newAvatarUrl);
      }

      if (mounted) {
        AppSnackBar.show(context, l.profileUpdated, type: SnackBarType.success);
        setState(() {
          _editing = false;
          _saving = false;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          l.profileUpdateFailed,
          type: SnackBarType.error,
        );
        setState(() => _saving = false);
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (ref.watch(authProvider) is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.editProfile),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const GuestAuthPrompt(icon: Icons.person_outline),
      );
    }
    final state = ref.watch(profileProvider);
    final userData = state.userData;
    final avatarUrl = Formatters.avatarUrl(userData);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(l.editProfile),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!_editing)
            TextButton(
              onPressed: () => setState(() => _editing = true),
              child: Text(l.edit),
            )
          else
            TextButton(
              onPressed: () => setState(() {
                _editing = false;
                _loadFromProfile();
              }),
              child: Text(l.cancel),
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
                          image:
                              (!(_avatarFile != null &&
                                      isVideoPath(_avatarFile!.path)) &&
                                  (_avatarFile != null || avatarUrl != null))
                              ? DecorationImage(
                                  image: _avatarFile != null
                                      ? FileImage(_avatarFile!) as ImageProvider
                                      : CachedNetworkImageProvider(
                                          Formatters.imageUrl(avatarUrl!),
                                        ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: AppColors.secondaryColor.withAlpha(60),
                        ),
                        child:
                            (_avatarFile != null &&
                                isVideoPath(_avatarFile!.path))
                            ? Icon(
                                Icons.videocam,
                                size: 48,
                                color: AppColors.textTertiary,
                              )
                            : (_avatarFile == null && avatarUrl == null)
                            ? Icon(
                                Icons.person,
                                size: 48,
                                color: AppColors.textTertiary,
                              )
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
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── Nama ────────────────────────────────────────────────────
              AppTextField(
                label: l.firstName,
                controller: _firstNameController,
                readOnly: !_editing,
              ),
              const SizedBox(height: AppSizes.sm),
              AppTextField(
                label: l.middleName,
                controller: _midNameController,
                readOnly: !_editing,
              ),
              const SizedBox(height: AppSizes.sm),
              AppTextField(
                label: l.lastName,
                controller: _lastNameController,
                readOnly: !_editing,
              ),

              const SizedBox(height: AppSizes.md),

              // ── Username ─────────────────────────────────────────────────
              AppTextField(
                label: l.username,
                controller: _usernameController,
                readOnly: !_editing,
                validator: _editing ? Validators.required : null,
              ),
              const SizedBox(height: AppSizes.sm),

              const SizedBox(height: AppSizes.sm),

              // ── WhatsApp ─────────────────────────────────────────────────
              _editing
                  ? AppTextField(
                      label: l.whatsapp,
                      controller: _whatsappController,
                      keyboardType: TextInputType.number,
                      validator: Validators.phone,
                      prefix: GestureDetector(
                        onTap: () async {
                          final code = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) =>
                                _CountryCodeSheet(selectedCode: _countryCode),
                          );
                          if (code != null) setState(() => _countryCode = code);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                flagFromDialCode(_countryCode) ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _countryCode,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : _buildReadOnlySection(
                      label: l.whatsapp,
                      value: _whatsappController.text.isEmpty
                          ? '-'
                          : '$_countryCode ${_whatsappController.text}',
                    ),

              if (_editing) ...[
                const SizedBox(height: AppSizes.xs),
                WhatsappOtpVerifier(
                  numberController: _whatsappController,
                  countryCode: _countryCode,
                  initialFullNumber: _initialWhatsapp,
                  minDigits: 10,
                  onVerifiedChanged: (v) {
                    if (_whatsappVerified != v) {
                      setState(() => _whatsappVerified = v);
                    }
                  },
                ),
              ],

              const SizedBox(height: AppSizes.xl),

              // ── Tombol Simpan (hanya saat edit) ──────────────────────────
              if (_editing)
                AppButton(
                  label: l.saveChanges,
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
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
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
              color: value == '-'
                  ? AppColors.textTertiary
                  : AppColors.textPrimary,
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
    final l = AppLocalizations.of(context)!;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(l.selectCountryCode, style: AppTextStyles.titleSmall),
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
