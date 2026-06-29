import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/ktp_utils.dart';
import '../../../../core/utils/passport_utils.dart';
import '../../../../core/utils/sim_utils.dart';
import '../../../../core/utils/npwp_utils.dart';
import '../../../../core/utils/country_codes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_date_picker_field.dart';
import '../../../../core/widgets/app_country_picker_field.dart';
import '../../../../core/widgets/app_region_picker_field.dart';
import '../../../legal/data/models/legal_model.dart';
import '../../../legal/presentation/providers/legal_provider.dart';
import '../providers/auth_provider.dart';
import 'auth_header.dart';
import 'social_login_button.dart';

enum AgreementMode { wizard, terms, privacy, weddingPolicy }

void showAgreementModal(BuildContext context, {AgreementMode mode = AgreementMode.wizard, VoidCallback? onAgreed}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AgreementModal(mode: mode, onAgreed: onAgreed),
  );
}

class _AgreementModal extends StatefulWidget {
  final AgreementMode mode;
  final VoidCallback? onAgreed;
  const _AgreementModal({this.mode = AgreementMode.wizard, this.onAgreed});

  @override
  State<_AgreementModal> createState() => _AgreementModalState();
}

class _AgreementModalState extends State<_AgreementModal> {
  late int _step;

  @override
  void initState() {
    super.initState();
    _step = widget.mode == AgreementMode.wizard ? 1 : 1;
  }

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final isWizard = widget.mode == AgreementMode.wizard;
    final isWedding = widget.mode == AgreementMode.weddingPolicy;

    String title;
    if (isWedding) {
      title = 'Kebijakan Aplikasi';
    } else if (_step == 1) {
      title = 'Ketentuan Layanan';
    } else if (_step == 2) {
      title = 'Kebijakan Privasi';
    } else {
      title = 'Kebijakan Aplikasi';
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _close,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.dividerColor),
            Expanded(
              child: isWedding
                  ? _LegalContentView(
                      provider: weddingDecorationPolicyProvider,
                      isWizard: false,
                      onNext: null,
                      onAgreed: null,
                      onClose: _close,
                    )
                  : (_step == 1
                      ? _LegalContentView(
                          provider: termsOfServiceProvider,
                          isWizard: isWizard,
                          onNext: isWizard ? () => setState(() => _step = 2) : null,
                          onClose: !isWizard ? _close : null,
                        )
                      : (_step == 2
                          ? _LegalContentView(
                              provider: privacyPolicyProvider,
                              isWizard: isWizard,
                              onNext: isWizard ? () => setState(() => _step = 3) : null,
                              onClose: !isWizard ? _close : null,
                            )
                          : _LegalContentView(
                              provider: weddingDecorationPolicyProvider,
                              isWizard: isWizard,
                              onNext: null,
                              onAgreed: isWizard
                                  ? () {
                                      widget.onAgreed?.call();
                                      _close();
                                    }
                                  : null,
                              onClose: !isWizard ? _close : null,
                            ))),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalContentView extends ConsumerWidget {
  final FutureProvider<LegalContent> provider;
  final bool isWizard;
  final VoidCallback? onNext;
  final VoidCallback? onAgreed;
  final VoidCallback? onClose;

  const _LegalContentView({
    required this.provider,
    this.isWizard = false,
    this.onNext,
    this.onAgreed,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);

    return async.when(
      loading: () => const Center(child: AppShimmer(width: 200, height: 16)),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text('Gagal memuat halaman',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.invalidate(provider),
                icon: const Icon(Icons.refresh, size: 18),
                label: Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
      data: (content) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(content.title,
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                  if (content.updatedAt != null) ...[
                    const SizedBox(height: 8),
                    Text('${'Terakhir diperbarui'}: ${content.updatedAt}',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 16),
                  if (content.content is List)
                    ...(content.content as List).map<Widget>((section) {
                      final heading = section['heading'] as String?;
                      final body = section['body'] as String?;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (heading != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(heading, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                              ),
                            Text(body ?? '', textAlign: TextAlign.justify, style: GoogleFonts.inter(fontSize: 14, height: 1.6)),
                          ],
                        ),
                      );
                    })
                  else
                    Text(
                      content.content is String
                          ? content.content as String
                          : (content.content is Map ? (content.content?['text'] as String? ?? (content.content?['content'] as String? ?? '')) : ''),
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.inter(fontSize: 14, height: 1.6),
                    ),
                ],
              ),
            ),
          ),
          if (onNext != null || onAgreed != null || onClose != null)
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.dividerColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onNext != null)
                    AppButton(
                      label: 'Lanjutkan',
                      onPressed: onNext,
                      type: ButtonType.primary,
                      width: 140,
                    ),
                  if (onAgreed != null)
                    Expanded(
                      child: AppButton(
                        label: 'Saya Mengerti & Setuju',
                        onPressed: onAgreed,
                        type: ButtonType.primary,
                      ),
                    ),
                  if (onClose != null)
                    AppButton(
                      label: 'Tutup',
                      onPressed: onClose,
                      type: ButtonType.outline,
                      width: 120,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showSignInSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _SignInSheetContent()),
  );
}

Future<void> showSignUpSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _SignUpSheetContent()),
  );
}

Future<void> showForgotPasswordSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _ForgotPasswordSheetContent()),
  );
}

class _AuthSheetWrapper extends StatelessWidget {
  final Widget child;
  const _AuthSheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(child: child),
        ],
      ),
    );
  }
}

class _SignInSheetContent extends ConsumerStatefulWidget {
  const _SignInSheetContent();

  @override
  ConsumerState<_SignInSheetContent> createState() => _SignInSheetContentState();
}

class _SignInSheetContentState extends ConsumerState<_SignInSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeTerms = false;
  bool _rememberMe = false;
  String _loginType = 'email';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _loginLabel {
    switch (_loginType) {
      case 'nik':
        return 'Nomer Induk Kependudukan (NIK)';
      case 'passport':
        return 'Nomer Passport';
      case 'sim':
        return 'Surat Izin Mengemudi (SIM)';
      case 'npwp':
        return 'Nomor Pokok Wajib Pajak (NPWP)';
      case 'username':
        return 'Username';
      default:
        return 'Email';
    }
  }

  TextInputType get _loginKeyboardType {
    switch (_loginType) {
      case 'nik':
      case 'npwp':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  Widget _buildLoginTypeSelector() {
    final types = ['email', 'username', 'nik', 'passport', 'sim', 'npwp'];
    final labels = {'email': 'Email', 'username': 'Username', 'nik': 'NIK', 'passport': 'Passport', 'sim': 'SIM', 'npwp': 'NPWP'};
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((key) {
        final isSelected = _loginType == key;
        final label = labels[key]!;
          return Padding(
            padding: EdgeInsets.only(left: key == 'email' ? 0 : 4),
            child: SizedBox(
              height: 32,
              child: OutlinedButton(
            onPressed: () {
              setState(() {
                _loginType = key;
                _emailController.clear();
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: isSelected ? AppColors.primaryColor : Colors.transparent,
              side: BorderSide(color: isSelected ? AppColors.primaryColor : AppColors.textTertiary),
              foregroundColor: isSelected ? Colors.white : AppColors.textSecondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
          ),
        ),
        );
        }).toList(),
      ),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      _showWarning('Anda harus menyetujui perjanjian untuk melanjutkan.');
      return;
    }
    if (!_rememberMe) {
      _showWarning('Centang Ingat Saya terlebih dahulu');
      return;
    }
    ref.read(authProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _onGoogleLogin() async {
    if (!_agreeTerms) {
      _showWarning('Anda harus menyetujui perjanjian untuk melanjutkan.');
      return;
    }
    if (!_rememberMe) {
      _showWarning('Centang Ingat Saya terlebih dahulu');
      return;
    }
    await ref.read(authProvider.notifier).googleLogin();
  }

  void _showWarning(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.warningColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        if (state.needsOtp) {
          Navigator.of(context).pop();
          GoRouter.of(context).push('/verify-otp', extra: {'email': state.user.email, 'purpose': 'google_register'});
        } else if (state.needsCompletion) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lengkapi profil Anda'), backgroundColor: AppColors.infoColor),
          );
          GoRouter.of(context).push('/edit-profile');
        } else {
          final messenger = ScaffoldMessenger.of(context);
          final router = GoRouter.of(context);
          Navigator.of(context).pop();
          messenger.showSnackBar(
            SnackBar(content: Text('Login berhasil'), backgroundColor: AppColors.successColor),
          );
          router.go('/home');
        }
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: AppColors.errorColor),
        );
      }
    });

    final isLoading = authState is AuthLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AuthHeader(title: 'Selamat datang,', subtitle: 'Masuk ke akun Anda'),
            const SizedBox(height: AppSizes.lg),
            _buildLoginTypeSelector(),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: _loginLabel,
              controller: _emailController,
              keyboardType: _loginKeyboardType,
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Kata Sandi', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showForgotPasswordSheet(context);
                  },
                  child: Text('Lupa Password?', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            AppTextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: Validators.password,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            _agreementCheckbox(),
            const SizedBox(height: AppSizes.sm),
            _rememberCheckbox(),
            const SizedBox(height: AppSizes.md),
            AppButton(
              label: 'Masuk',
              loading: isLoading,
              disabled: !_agreeTerms || !_rememberMe,
              onPressed: _onLogin,
              type: ButtonType.primaryGradient,
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Text('Atau', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            SocialLoginButton(provider: SocialProvider.google, enabled: _agreeTerms && _rememberMe, onPressed: _onGoogleLogin),
            const SizedBox(height: AppSizes.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum punya akun?', style: AppTextStyles.bodyMedium),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showSignUpSheet(context);
                  },
                  child: Text('Daftar', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _agreementCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeTerms,
            onChanged: (v) {
              if (v == true) {
                showAgreementModal(context, mode: AgreementMode.wizard, onAgreed: () {
                  setState(() => _agreeTerms = true);
                });
              } else {
                setState(() => _agreeTerms = false);
              }
            },
            activeColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!_agreeTerms) {
                showAgreementModal(context, mode: AgreementMode.wizard, onAgreed: () {
                  setState(() => _agreeTerms = true);
                });
              } else {
                setState(() => _agreeTerms = false);
              }
            },
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                children: [
                  const TextSpan(text: 'Dengan mencentang Setuju & Bergabung atau Lanjutkan, Anda menyetujui '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => showAgreementModal(context, mode: AgreementMode.terms),
                      child: Text(
                        'Perjanjian Pengguna',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ', '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => showAgreementModal(context, mode: AgreementMode.privacy),
                      child: Text(
                        'Kebijakan Privasi',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' dan '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => showAgreementModal(context, mode: AgreementMode.weddingPolicy),
                      child: Text(
                        'Kebijakan Aplikasi',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' Wedding Flowers Decorasi.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rememberCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (v) => setState(() => _rememberMe = v ?? false),
            activeColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Text(
              'Ingat Saya',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

class _SignUpSheetContent extends ConsumerStatefulWidget {
  const _SignUpSheetContent();

  @override
  ConsumerState<_SignUpSheetContent> createState() => _SignUpSheetContentState();
}

class _SignUpSheetContentState extends ConsumerState<_SignUpSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _nikController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _countryController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _rememberMe = false;
  File? _avatarFile;
  File? _ktpFile;
  File? _selfieKtpFile;
  bool _namesLocked = false;
  String _ocrExtractedName = '';
  int? _provinceId;
  int? _cityId;
  int? _districtId;
  int? _villageId;
  String _provinceName = '';
  String _cityName = '';
  String _districtName = '';
  String _villageName = '';
  String _postalCode = '';
  String _identityType = 'ktp';
  String _countryCode = '+62';

  String get _idLabel {
    switch (_identityType) {
      case 'ktp': return 'Nomer Induk Kependudukan (NIK)';
      case 'passport': return 'Nomer Passport';
      case 'sim': return 'Surat Izin Mengemudi (SIM)';
      case 'npwp': return 'Nomor Pokok Wajib Pajak (NPWP)';
      default: return 'Nomor Identitas';
    }
  }
  String get _idPhotoLabel {
    switch (_identityType) {
      case 'ktp': return 'Foto KTP';
      case 'passport': return 'Foto Passport';
      case 'sim': return 'Foto SIM';
      case 'npwp': return 'Foto NPWP';
      default: return 'Foto Identitas';
    }
  }
  String get _idSelfieLabel {
    switch (_identityType) {
      case 'ktp': return 'Foto Selfie + KTP';
      case 'passport': return 'Foto Selfie + Passport';
      case 'sim': return 'Foto Selfie + SIM';
      case 'npwp': return 'Foto Selfie + NPWP';
      default: return 'Foto Selfie + Identitas';
    }
  }

  String get _fullName => [
    _firstNameController.text.trim(),
    _middleNameController.text.trim(),
    _lastNameController.text.trim(),
  ].where((s) => s.isNotEmpty).join(' ');

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _nikController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showIdentityTypeSheet() {
    showModalBottomSheet(
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
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 8),
              Text('Pilih Jenis Identitas', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text('Kartu Tanda Kependudukan (KTP)', style: AppTextStyles.bodyMedium),
                trailing: _identityType == 'ktp' ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                onTap: () {
                  setState(() {
                    _identityType = 'ktp';
                    _ktpFile = null;
                    _nikController.clear();
                    _namesLocked = false;
                    _ocrExtractedName = '';
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_travel),
                title: Text('Passport', style: AppTextStyles.bodyMedium),
                trailing: _identityType == 'passport' ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                onTap: () {
                  setState(() {
                    _identityType = 'passport';
                    _ktpFile = null;
                    _nikController.clear();
                    _namesLocked = false;
                    _ocrExtractedName = '';
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_eta),
                title: Text('Surat Izin Mengemudi (SIM)', style: AppTextStyles.bodyMedium),
                trailing: _identityType == 'sim' ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                onTap: () {
                  setState(() {
                    _identityType = 'sim';
                    _ktpFile = null;
                    _nikController.clear();
                    _namesLocked = false;
                    _ocrExtractedName = '';
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text('Nomor Pokok Wajib Pajak (NPWP)', style: AppTextStyles.bodyMedium),
                trailing: _identityType == 'npwp' ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                onTap: () {
                  setState(() {
                    _identityType = 'npwp';
                    _ktpFile = null;
                    _nikController.clear();
                    _namesLocked = false;
                    _ocrExtractedName = '';
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentityTypePicker() {
    final (icon, label) = switch (_identityType) {
      'ktp' => (Icons.credit_card, 'Kartu Tanda Kependudukan (KTP)'),
      'passport' => (Icons.card_travel, 'Passport'),
      'sim' => (Icons.drive_eta, 'Surat Izin Mengemudi (SIM)'),
      'npwp' => (Icons.receipt_long, 'Nomor Pokok Wajib Pajak (NPWP)'),
      _ => (Icons.credit_card, 'Pilih Jenis Identitas'),
    };
    return GestureDetector(
      onTap: _showIdentityTypeSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 22),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage({required bool isKtp}) async {
    if (isKtp) {
      final file = await pickKtpPhoto(context);
      if (file != null) {
        setState(() => _ktpFile = file);
        String nik = '';
        String name = '';
        if (_identityType == 'ktp') {
          nik = await extractNikFromKtp(file);
          name = await extractNameFromKtp(file);
        } else if (_identityType == 'passport') {
          nik = await extractPassportNumber(file);
          name = await extractNameFromPassport(file);
        } else if (_identityType == 'sim') {
          nik = await extractSimNumber(file);
          name = await extractNameFromSim(file);
        } else if (_identityType == 'npwp') {
          nik = await extractNpwpNumber(file);
          name = await extractNameFromNpwp(file);
        }
        setState(() {
          _ocrExtractedName = name;
          if (nik.isNotEmpty) _nikController.text = nik;
        });
        if (name.isNotEmpty) {
          final parts = splitKtpName(name);
          setState(() {
            _firstNameController.text = parts[0];
            _middleNameController.text = parts[1];
            _lastNameController.text = parts[2];
            _namesLocked = true;
          });
        }
      }
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));
    }
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      _showWarning('Anda harus menyetujui perjanjian untuk melanjutkan.');
      return;
    }
    if (!_rememberMe) {
      _showWarning('Centang Ingat Saya terlebih dahulu');
      return;
    }
    if (_ktpFile != null) {
      if (!_namesLocked && _ocrExtractedName.isEmpty) {
        _showWarning('Nama gagal diverifikasi dari $_idPhotoLabel. Upload ulang dengan foto yang jelas.');
        return;
      }
      if (_ocrExtractedName.isNotEmpty) {
        final enteredName = _fullName.toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
        final ocrName = _ocrExtractedName.toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
        if (!enteredName.contains(ocrName) && !ocrName.contains(enteredName)) {
          _showWarning('Nama tidak sesuai dengan $_idPhotoLabel');
          return;
        }
      }
    }
    ref.read(authProvider.notifier).register(
      fullName: _fullName,
      firstName: _firstNameController.text.trim(),
      middleName: _middleNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      whatsapp: '$_countryCode ${_whatsappController.text.trim()}',
      nik: _identityType == 'ktp' ? _nikController.text.trim() : '',
      passportNumber: _identityType == 'passport' ? _nikController.text.trim() : null,
      simNumber: _identityType == 'sim' ? _nikController.text.trim() : null,
      npwpNumber: _identityType == 'npwp' ? _nikController.text.trim() : null,
      identityType: _identityType,
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      country: _countryController.text.trim(),
      provinceId: _provinceId,
      cityId: _cityId,
      districtId: _districtId,
      villageId: _villageId,
      provinceName: _provinceName,
      cityName: _cityName,
      districtName: _districtName,
      villageName: _villageName,
      postalCode: _postalCode,
      address: _addressController.text.trim(),
      ktpPhotoPath: _ktpFile?.path,
      selfiePhotoPath: _selfieKtpFile?.path,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
  }

  void _showWarning(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.warningColor),
    );
  }

  Widget _buildPhoneField() {
    return Row(
      children: [
        SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: () => _showCountryCodePicker(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.dividerColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text(_countryCode, style: AppTextStyles.bodyMedium),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppTextField(
            label: 'WhatsApp',
            controller: _whatsappController,
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
          ),
        ),
      ],
    );
  }

  void _showCountryCodePicker() {
    final searchController = TextEditingController();
    final filteredCodes = ValueNotifier(List.of(countryCodes));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari negara...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (v) {
                      setSheetState(() {
                        filteredCodes.value = countryCodes.where((c) =>
                          c.name.toLowerCase().contains(v.toLowerCase()) ||
                          c.dialCode.contains(v)).toList();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ValueListenableBuilder(
                    valueListenable: filteredCodes,
                    builder: (_, codes, _) => ListView.separated(
                      shrinkWrap: true,
                      itemCount: codes.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) => ListTile(
                        dense: true,
                        leading: Text(codes[i].flag, style: const TextStyle(fontSize: 22)),
                        title: Text(codes[i].name, style: AppTextStyles.bodyMedium),
                        trailing: Text(codes[i].dialCode, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        onTap: () {
                          setState(() => _countryCode = codes[i].dialCode);
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPasswordStrength(String password) {
    final checks = [
      password.length >= 12,
      password.contains(RegExp(r'[A-Z]')),
      password.contains(RegExp(r'[a-z]')),
      password.contains(RegExp(r'[0-9]')),
      password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
    ];
    final score = checks.where((c) => c).length;
    final (label, color, value) = switch (score) {
      0 || 1 => ('Lemah', AppColors.errorColor, 0.2),
      2 || 3 => ('Sedang', AppColors.warningColor, 0.5),
      _ => ('Kuat', AppColors.successColor, 0.9),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: AppColors.dividerColor,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        final messenger = ScaffoldMessenger.of(context);
        final router = GoRouter.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(content: Text('Registrasi berhasil'), backgroundColor: AppColors.successColor),
        );
        router.go('/home');
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: AppColors.errorColor),
        );
      }
    });

    final isLoading = authState is AuthLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.sm),
            Center(child: Text('Daftar Akun', style: AppTextStyles.headlineMedium)),
            const SizedBox(height: AppSizes.xs),
            Center(child: Text('Isi data diri Anda dengan benar', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary))),

            const SizedBox(height: AppSizes.lg),
            Center(
              child: GestureDetector(
                onTap: () => _pickImage(isKtp: false),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.secondaryColor,
                      backgroundImage: _avatarFile != null ? FileImage(_avatarFile!) : null,
                      child: _avatarFile == null
                          ? Icon(Icons.camera_alt, size: 28, color: AppColors.primaryColor)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            AppTextField(
              label: 'Nama Depan',
              controller: _firstNameController,
              readOnly: _namesLocked,
              validator: Validators.required,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: AppSizes.md),
            AppTextField(
              label: 'Nama Tengah',
              controller: _middleNameController,
              readOnly: _namesLocked,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: AppSizes.md),
            AppTextField(
              label: 'Nama Belakang',
              controller: _lastNameController,
              readOnly: _namesLocked,
              validator: Validators.required,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.badge_outlined, size: 18, color: AppColors.textSecondary),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      _fullName.isNotEmpty ? _fullName : 'Nama Anda akan tampil di sini',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _fullName.isNotEmpty ? AppColors.textPrimary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: 'Username',
              controller: _usernameController,
              validator: Validators.required,
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(height: AppSizes.lg),
            Text('Pilih Jenis Identitas', style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
            _buildIdentityTypePicker(),
            SizedBox(height: AppSizes.md),
            GestureDetector(
              onTap: () => _pickImage(isKtp: true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: _ktpFile != null ? AppColors.successColor.withAlpha(20) : AppColors.secondaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _ktpFile != null ? AppColors.successColor : AppColors.dividerColor,
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _ktpFile != null ? Icons.check_circle : Icons.credit_card_outlined,
                      color: _ktpFile != null ? AppColors.successColor : AppColors.textSecondary,
                      size: 28,
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_idPhotoLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text(
                            _ktpFile != null ? '$_idPhotoLabel berhasil diupload' : 'Upload $_idPhotoLabel',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: _ktpFile != null ? AppColors.successColor : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_ktpFile != null)
                      GestureDetector(
                        onTap: () => setState(() => _ktpFile = null),
                        child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSizes.sm),
            GestureDetector(
              onTap: () async {
                final file = await pickKtpPhoto(context);
                if (file != null) setState(() => _selfieKtpFile = file);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: _selfieKtpFile != null ? AppColors.successColor.withAlpha(20) : AppColors.secondaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _selfieKtpFile != null ? AppColors.successColor : AppColors.dividerColor,
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selfieKtpFile != null ? Icons.check_circle : Icons.person,
                      color: _selfieKtpFile != null ? AppColors.successColor : AppColors.textSecondary,
                      size: 28,
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_idSelfieLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text(
                            _selfieKtpFile != null ? '$_idSelfieLabel berhasil diupload' : 'Upload $_idSelfieLabel',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: _selfieKtpFile != null ? AppColors.successColor : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_selfieKtpFile != null)
                      GestureDetector(
                        onTap: () => setState(() => _selfieKtpFile = null),
                        child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSizes.md),
            AppTextField(
              label: _idLabel,
              controller: _nikController,
              keyboardType: _identityType == 'ktp' ? TextInputType.number : TextInputType.text,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '$_idLabel wajib diisi';
                if (_identityType == 'ktp' && v.trim().length != 16) return 'NIK harus 16 digit';
                if (_identityType == 'sim' && v.trim().length < 6) return 'Nomor SIM minimal 6 karakter';
                if (_identityType == 'npwp' && v.trim().length < 15) return 'Nomor NPWP minimal 15 digit';
                if (!['ktp', 'sim', 'npwp'].contains(_identityType) && v.trim().length < 6) return '$_idLabel minimal 6 karakter';
                return null;
              },
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(height: AppSizes.sm),
            AppTextField(
              label: 'Tempat',
              controller: _birthPlaceController,
            ),
            SizedBox(height: AppSizes.md),
            AppDatePickerField(
              label: 'Tanggal Lahir',
              controller: _birthDateController,
            ),
            SizedBox(height: AppSizes.md),
            AppCountryPickerField(
              label: 'Negara',
              controller: _countryController,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: AppSizes.md),
            AppRegionPickerField(
              country: _countryController.text.isEmpty ? null : _countryController.text,
              onProvinceIdChanged: (id) => _provinceId = id,
              onCityIdChanged: (id) => _cityId = id,
              onDistrictIdChanged: (id) => _districtId = id,
              onVillageIdChanged: (id) => _villageId = id,
              onProvinceNameChanged: (v) => _provinceName = v,
              onCityNameChanged: (v) => _cityName = v,
              onDistrictNameChanged: (v) => _districtName = v,
              onVillageNameChanged: (v) => _villageName = v,
              onPostalCodeChanged: (v) => _postalCode = v,
            ),
            AppTextField(
              label: 'Detail Alamat',
              controller: _addressController,
              maxLines: 2,
            ),
            _buildPhoneField(),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: 'Kata Sandi',
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: Validators.password,
              onChanged: (_) => setState(() {}),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 6),
              _buildPasswordStrength(_passwordController.text),
            ],
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: 'Konfirmasi Kata Sandi',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              validator: (v) => Validators.confirmPassword(v, _passwordController.text),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            _agreementCheckbox(),
            const SizedBox(height: AppSizes.sm),
            _rememberCheckbox(),
            const SizedBox(height: AppSizes.lg),
            AppButton(
              label: 'Daftar Sekarang',
              loading: isLoading,
              disabled: !_agreeTerms || !_rememberMe,
              onPressed: _onRegister,
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun?', style: AppTextStyles.bodyMedium),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showSignInSheet(context);
                  },
                  child: Text('Masuk', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _agreementCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeTerms,
            onChanged: (v) {
              if (v == true) {
                showAgreementModal(context, mode: AgreementMode.wizard, onAgreed: () {
                  setState(() => _agreeTerms = true);
                });
              } else {
                setState(() => _agreeTerms = false);
              }
            },
            activeColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!_agreeTerms) {
                showAgreementModal(context, mode: AgreementMode.wizard, onAgreed: () {
                  setState(() => _agreeTerms = true);
                });
              } else {
                setState(() => _agreeTerms = false);
              }
            },
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                children: [
                  const TextSpan(text: 'Dengan mencentang Setuju & Bergabung atau Lanjutkan, Anda menyetujui '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => showAgreementModal(context, mode: AgreementMode.terms),
                      child: Text(
                        'Perjanjian Pengguna',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ', '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => showAgreementModal(context, mode: AgreementMode.privacy),
                      child: Text(
                        'Kebijakan Privasi',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' dan '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => showAgreementModal(context, mode: AgreementMode.weddingPolicy),
                      child: Text(
                        'Kebijakan Aplikasi',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' Wedding Flowers Decorasi.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rememberCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (v) => setState(() => _rememberMe = v ?? false),
            activeColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Text(
              'Ingat Saya',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordSheetContent extends StatefulWidget {
  const _ForgotPasswordSheetContent();

  @override
  State<_ForgotPasswordSheetContent> createState() => _ForgotPasswordSheetContentState();
}

class _ForgotPasswordSheetContentState extends State<_ForgotPasswordSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await DioClient.instance.post(
        ApiEndpoints.forgotPassword,
        data: {'email': _emailController.text.trim()},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kode reset telah dikirim ke email Anda'), backgroundColor: AppColors.successColor),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim kode reset. Coba lagi.'), backgroundColor: AppColors.errorColor),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.sm),
            Text('Lupa Password?', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Masukkan email Anda untuk menerima kode reset password',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.xl),
            AppTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSizes.xl),
            AppButton(
              label: 'Kirim Kode Reset',
              loading: _loading,
              onPressed: _onSendResetCode,
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}
