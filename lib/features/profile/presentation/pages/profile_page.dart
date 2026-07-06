import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/auth_modals.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileProvider.notifier).fetchProfile());
  }

  Future<void> _logout() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.signOut),
        content: Text(l.confirmSignOut),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          AppButton(
            label: l.signOut,
            onPressed: () => Navigator.pop(ctx, true),
            type: ButtonType.primary,
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go('/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(profileProvider);
    final userData = state.userData;
    final isAdmin = ref.watch(authProvider) is AuthAuthenticated && (ref.watch(authProvider) as AuthAuthenticated).user.isAdmin;

    return Scaffold(
      body: state.loading
          ? ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                SizedBox(height: AppSizes.xxl),
                Center(child: AppShimmer(width: 96, height: 96, borderRadius: 48)),
                SizedBox(height: AppSizes.md),
                Center(child: AppShimmer(width: 160, height: 20)),
                SizedBox(height: AppSizes.sm),
                Center(child: AppShimmer(width: 120, height: 14)),
                SizedBox(height: AppSizes.lg),
                ...List.generate(7, (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: AppShimmer(height: 56, borderRadius: 12),
                )),
              ],
            )
          : RefreshIndicator(
              onRefresh: () => ref.read(profileProvider.notifier).fetchProfile(),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.xxl, AppSizes.md, AppSizes.lg),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primaryColor.withAlpha(25),
                          backgroundImage: Formatters.avatarUrl(userData) != null
                              ? CachedNetworkImageProvider(Formatters.avatarUrl(userData)!)
                              : null,
                          child: Formatters.avatarUrl(userData) == null
                              ? Icon(Icons.person, size: 48, color: AppColors.primaryColor)
                              : null,
                        ),
                        SizedBox(height: AppSizes.md),
                        Text(
                          userData?['full_name'] as String? ?? '',
                          style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${userData?['username'] as String? ?? ''}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          userData?['email'] as String? ?? '',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (!isAdmin) _buildProfileCompletion(ref, userData),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: Column(
                      children: [
                        _menuTile(Icons.edit, l.editProfile, () => context.push('/edit-profile')),
                        _menuTile(Icons.settings, l.settings, () => context.push('/settings')),
                        if (!isAdmin)
                          _menuTile(Icons.card_giftcard, l.myVouchers, () => context.push('/vouchers')),
                        _menuTile(Icons.privacy_tip, l.privacyAndTerms, () => context.push('/legal/privacy-term')),
                        _menuTile(Icons.help, l.helpCenter, () => context.push('/help-center')),
                        _menuTile(Icons.logout, l.signOut, _logout, isDestructive: true),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.xl),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCompletion(WidgetRef ref, Map<String, dynamic>? userData) {
    final l = AppLocalizations.of(context)!;
    final pState = ref.watch(profileProvider);
    final percent = pState.completionPercent;
    final items = pState.completionItems;

    if (items == null) {
      ref.read(profileProvider.notifier).fetchCompletion();
      return const SizedBox.shrink();
    }

    final identityVerified = userData?['identity_verified_at'] != null;
    final selfieUrl = userData?['selfie_photo_url'] as String?;

    final firstName = (userData?['first_name'] as String? ?? '').trim();
    final midName  = (userData?['mid_name']   as String? ?? '').trim();
    final lastName = (userData?['last_name']  as String? ?? '').trim();
    final hasFullName = firstName.isNotEmpty || midName.isNotEmpty || lastName.isNotEmpty;

    final missingFields = <_ProfileTask>[];
    if (!hasFullName) {
      missingFields.add(_ProfileTask(
        key: 'full_name', icon: Icons.person_outline_rounded,
        label: l.fillFirstName,
        action: l.fillLabel, section: 'name',
      ));
    }
    if (items['username'] == false) {
      missingFields.add(_ProfileTask(
        key: 'username', icon: Icons.alternate_email_rounded,
        label: l.createUniqueUsername,
        action: l.actionCreate, section: 'username',
      ));
    }
    if (items['avatar_url'] == false) {
      missingFields.add(_ProfileTask(
        key: 'avatar_url', icon: Icons.account_circle_outlined,
        label: l.uploadProfilePhoto,
        action: l.actionUpload, section: 'avatar',
      ));
    }
    if (items['whatsapp'] == false) {
      missingFields.add(_ProfileTask(
        key: 'whatsapp', icon: Icons.phone_outlined,
        label: l.addActiveWhatsapp,
        action: l.actionAdd, section: 'whatsapp',
      ));
    }
    if (items['email_verified'] == false) {
      missingFields.add(_ProfileTask(
        key: 'email_verified', icon: Icons.mark_email_unread_outlined,
        label: l.verifyEmailAddress,
        action: l.verify, section: 'username',
      ));
    }
    if (items['nik'] == false) {
      missingFields.add(_ProfileTask(
        key: 'nik', icon: Icons.badge_outlined,
        label: l.idNumber,
        action: l.fillLabel, section: 'identity',
      ));
    }

    if (!identityVerified) {
      final birthPlace = (userData?['birth_place'] as String? ?? '').trim();
      if (birthPlace.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'birth_place', icon: Icons.location_city_outlined,
          label: l.fillPlaceOfBirth,
          action: l.fillLabel, section: 'identity',
        ));
      }
      final birthDate = (userData?['birth_date'] as String? ?? '').trim();
      if (birthDate.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'birth_date', icon: Icons.cake_outlined,
          label: l.fillDateOfBirth,
          action: l.fillLabel, section: 'identity',
        ));
      }
      final country = (userData?['country'] as String? ?? '').trim();
      if (country.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'country', icon: Icons.flag_outlined,
          label: l.selectCountry,
          action: l.actionPick, section: 'identity',
        ));
      }
      final provinceName = (userData?['province_name'] as String? ?? '').trim();
      if (provinceName.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'province', icon: Icons.map_outlined,
          label: l.selectProvince,
          action: l.actionPick, section: 'identity',
        ));
      }
      final cityName = (userData?['city_name'] as String? ?? '').trim();
      if (cityName.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'city', icon: Icons.location_on_outlined,
          label: l.selectCity,
          action: l.actionPick, section: 'identity',
        ));
      }
      final districtName = (userData?['district_name'] as String? ?? '').trim();
      if (districtName.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'district', icon: Icons.holiday_village_outlined,
          label: l.selectDistrict,
          action: l.actionPick, section: 'identity',
        ));
      }
      final villageName = (userData?['village_name'] as String? ?? '').trim();
      if (villageName.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'village', icon: Icons.home_work_outlined,
          label: l.selectVillage,
          action: l.actionPick, section: 'identity',
        ));
      }
      final postalCode = (userData?['postal_code'] as String? ?? '').trim();
      if (postalCode.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'postal_code', icon: Icons.markunread_mailbox_outlined,
          label: l.fillPostalCode,
          action: l.fillLabel, section: 'identity',
        ));
      }
      final address = (userData?['address'] as String? ?? '').trim();
      if (address.isEmpty) {
        missingFields.add(_ProfileTask(
          key: 'address', icon: Icons.edit_road_outlined,
          label: l.fillFullAddress,
          action: l.fillLabel, section: 'identity',
        ));
      }
      final gender = (userData?['gender'] as String? ?? '').trim();
      if (gender.isEmpty) {
        missingFields.add(_ProfileTask(key: 'gender', icon: Icons.people_outlined, label: l.selectGender, action: l.actionPick, section: 'identity'));
      }
      final religion = (userData?['religion'] as String? ?? '').trim();
      if (religion.isEmpty) {
        missingFields.add(_ProfileTask(key: 'religion', icon: Icons.church_outlined, label: l.selectReligion, action: l.actionPick, section: 'identity'));
      }
      final maritalStatus = (userData?['marital_status'] as String? ?? '').trim();
      if (maritalStatus.isEmpty) {
        missingFields.add(_ProfileTask(key: 'marital_status', icon: Icons.favorite_border, label: l.selectMaritalStatus, action: l.actionPick, section: 'identity'));
      }
      final motherName = (userData?['mother_name'] as String? ?? '').trim();
      if (motherName.isEmpty) {
        missingFields.add(_ProfileTask(key: 'mother_name', icon: Icons.woman_outlined, label: l.fillMotherName, action: l.fillLabel, section: 'identity'));
      }
      final occupation = (userData?['occupation'] as String? ?? '').trim();
      if (occupation.isEmpty) {
        missingFields.add(_ProfileTask(key: 'occupation', icon: Icons.work_outline, label: l.selectOccupation, action: l.actionPick, section: 'identity'));
      }
      final incomeRange = (userData?['income_range'] as String? ?? '').trim();
      if (incomeRange.isEmpty) {
        missingFields.add(_ProfileTask(key: 'income_range', icon: Icons.trending_up_outlined, label: l.selectIncomeRange, action: l.actionPick, section: 'identity'));
      }
      final sourceOfFunds = (userData?['source_of_funds'] as String? ?? '').trim();
      if (sourceOfFunds.isEmpty) {
        missingFields.add(_ProfileTask(key: 'source_of_funds', icon: Icons.account_balance_wallet_outlined, label: l.selectSourceOfFunds, action: l.actionPick, section: 'identity'));
      }
    }

    if (items['ktp_photo'] == false) {
      missingFields.add(_ProfileTask(
        key: 'ktp_photo', icon: Icons.credit_card_outlined,
        label: l.uploadIdPhoto,
        action: l.actionUpload, section: 'ktp_photo',
      ));
    }
    if (items['selfie_photo'] == false) {
      missingFields.add(_ProfileTask(
        key: 'selfie_photo', icon: Icons.face_outlined,
        label: l.uploadIdSelfie,
        action: l.actionUpload, section: 'selfie',
      ));
    }
    if (items['identity_verified'] == false) {
      missingFields.add(_ProfileTask(
        key: 'identity_verified', icon: Icons.face_retouching_natural_outlined,
        label: l.verifyWithCamera,
        action: l.actionScan, section: 'identity_verified',
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: identityVerified ? AppColors.successColor.withAlpha(25) : AppColors.warningColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      identityVerified ? Icons.verified : Icons.warning_amber_rounded,
                      color: identityVerified ? AppColors.successColor : AppColors.warningColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          identityVerified
                              ? l.verified100
                              : '${l.notVerified} ($percent%)',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (identityVerified && selfieUrl != null) ...[
                          SizedBox(height: 2),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: SizedBox(
                                  width: 24, height: 24,
                                  child: CachedNetworkImage(imageUrl: selfieUrl, fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  l.faceVerification,
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.successColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _navigateToTask(_ProfileTask(
                      key: 'identity_verified', icon: Icons.face_retouching_natural_outlined,
                      label: '', action: '', section: '',
                    )),
                    icon: Icon(
                      identityVerified ? Icons.refresh : Icons.camera_alt_outlined,
                      size: 16,
                    ),
                    label: Text(
                      identityVerified ? l.reVerify : l.verifyNow,
                      style: AppTextStyles.bodySmall,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: identityVerified ? AppColors.primaryColor : AppColors.warningColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 10,
                  backgroundColor: AppColors.secondaryColor.withAlpha(50),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percent >= 80 ? AppColors.successColor
                        : (percent >= 50 ? AppColors.warningColor : AppColors.primaryColor),
                  ),
                ),
              ),
              if (missingFields.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textTertiary),
                    SizedBox(width: 6),
                    Text(
                      l.dataNotFilled.replaceFirst('%s', '${missingFields.length}'),
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...missingFields.map((task) => _buildTaskRow(task)),
              ],
              if (!identityVerified) ...[
                const SizedBox(height: AppSizes.md),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: l.verifyNow,
                    onPressed: () {
                      if (missingFields.isNotEmpty) {
                        _navigateToTask(missingFields.first);
                      } else {
                        _navigateToTask(_ProfileTask(
                          key: 'identity_verified', icon: Icons.face_retouching_natural_outlined,
                          label: '', action: '', section: '',
                        ));
                      }
                    },
                    type: ButtonType.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTask(_ProfileTask task) async {
    final l = AppLocalizations.of(context)!;
    switch (task.key) {

      case 'email_verified':
        // Kirim OTP → halaman verifikasi OTP
        final userData = ref.read(profileProvider).userData;
        final email = userData?['email'] as String?;
        if (email == null || email.isEmpty) {
          AppSnackBar.show(context, l.emailNotFilled, type: SnackBarType.warning);
          return;
        }
        try {
          await ref.read(profileProvider.notifier).sendVerifyEmailOtp(email);
          if (mounted) {
            showOtpVerificationSheet(context, email: email, purpose: 'verify_email');
          }
        } catch (e) {
          if (mounted) {
            AppSnackBar.show(context, l.failedSendVerificationCode, type: SnackBarType.error);
          }
        }
        break;

      case 'identity_verified':
        context.push('/profile-field', extra: {'key': 'face_scan'});
        break;

      // Masing-masing field punya halaman tersendiri
      case 'full_name':
        context.push('/profile-field', extra: {'key': 'full_name'});
        break;
      case 'username':
        context.push('/profile-field', extra: {'key': 'username'});
        break;
      case 'avatar_url':
        context.push('/profile-field', extra: {'key': 'avatar'});
        break;
      case 'whatsapp':
        context.push('/profile-field', extra: {'key': 'whatsapp'});
        break;
      case 'nik':
        context.push('/profile-field', extra: {'key': 'nik'});
        break;
      case 'birth_place':
      case 'birth_date':
        // Tempat lahir & tanggal lahir → satu halaman bersama
        context.push('/profile-field', extra: {'key': 'birth'});
        break;
      case 'country':
        context.push('/profile-field', extra: {'key': 'country'});
        break;
      case 'province':
      case 'city':
      case 'district':
      case 'village':
      case 'postal_code':
        // Semua wilayah → satu halaman region
        context.push('/profile-field', extra: {'key': 'region'});
        break;
      case 'gender':
      case 'religion':
      case 'marital_status':
      case 'mother_name':
      case 'occupation':
      case 'income_range':
      case 'source_of_funds':
        context.push('/profile-field', extra: {'key': task.key});
        break;
      case 'address':
        context.push('/profile-field', extra: {'key': 'address'});
        break;
      case 'ktp_photo':
        context.push('/profile-field', extra: {'key': 'ktp_photo'});
        break;
      case 'selfie_photo':
        context.push('/profile-field', extra: {'key': 'selfie'});
        break;

      default:
        // Fallback: ke halaman lengkapi profil
        context.push('/complete-profile', extra: {'section': task.section});
    }
  }

  Widget _buildTaskRow(_ProfileTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(18),
              shape: BoxShape.circle,
            ),
            child: Icon(task.icon, size: 15, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              task.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          InkWell(
            onTap: () => _navigateToTask(task),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                task.action,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _menuTile(IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? AppColors.errorColor : AppColors.primaryColor),
        title: Text(label, style: AppTextStyles.bodyMedium.copyWith(
          color: isDestructive ? AppColors.errorColor : AppColors.textPrimary,
        )),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Simple immutable data class representing a pending profile task.
class _ProfileTask {
  final String key;
  final IconData icon;
  final String label;
  final String action;
  final String section;

  const _ProfileTask({
    required this.key,
    required this.icon,
    required this.label,
    required this.action,
    required this.section,
  });
}

