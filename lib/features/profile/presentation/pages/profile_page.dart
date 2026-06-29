import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Keluar'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Batal')),
          AppButton(
            label: 'Keluar',
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
    final state = ref.watch(profileProvider);
    final userData = state.userData;
    final stats = (userData?['stats'] as Map<String, dynamic>?) ?? {};

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
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(3, (_) => AppShimmer(width: 80, height: 40))),
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.xxl, AppSizes.md, AppSizes.lg),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          backgroundImage: userData?['avatar_url'] != null
                              ? CachedNetworkImageProvider(userData!['avatar_url'] as String)
                              : null,
                          child: userData?['avatar_url'] == null
                              ? const Icon(Icons.person, size: 48, color: Colors.white)
                              : null,
                        ),
                        SizedBox(height: AppSizes.md),
                        Text(
                          userData?['full_name'] as String? ?? 'Pengguna',
                          style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${userData?['username'] as String? ?? ''}',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                        ),
                        Text(
                          userData?['email'] as String? ?? '',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _statItem('Total Order', '${stats['orders_count'] ?? 0}'),
                            GestureDetector(
                              onTap: () => context.push('/wishlist'),
                              child: _statItem('Favorit', '${stats['wishlist_count'] ?? 0}'),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/my-reviews'),
                              child: _statItem('Ulasan', '${stats['reviews_count'] ?? 0}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildProfileCompletion(ref),
                  _buildIdentityVerification(userData),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: Column(
                      children: [
                        _menuTile(Icons.edit, 'Edit Profil', () => context.push('/edit-profile')),
                        _menuTile(Icons.card_giftcard, 'Voucher Saya', () => context.push('/vouchers')),
                        _menuTile(Icons.receipt_long, 'Pesanan Saya', () => context.push('/orders')),
                        _menuTile(Icons.privacy_tip, 'Privasi & Ketentuan', () => context.push('/legal/privacy-term')),
                        _menuTile(Icons.help, 'Pusat Bantuan', () => AppSnackBar.show(context, 'Fitur akan segera hadir', type: SnackBarType.info)),
                        _menuTile(Icons.logout, 'Keluar', _logout, isDestructive: true),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.xl),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCompletion(WidgetRef ref) {
    final pState = ref.watch(profileProvider);
    final percent = pState.completionPercent;
    final items = pState.completionItems;
    final userData = pState.userData;

    if (items == null) {
      ref.read(profileProvider.notifier).fetchCompletion();
      return const SizedBox.shrink();
    }

    // full_name is derived from first_name + mid_name + last_name (same as Sign Up)
    final firstName = (userData?['first_name'] as String? ?? '').trim();
    final midName  = (userData?['mid_name']   as String? ?? '').trim();
    final lastName = (userData?['last_name']  as String? ?? '').trim();
    final hasFullName = firstName.isNotEmpty || midName.isNotEmpty || lastName.isNotEmpty;

    // Map all 9 completion items returned by the API backend
    // API items: full_name, username, whatsapp, avatar_url, email_verified,
    //            nik, ktp_photo, selfie_photo, identity_verified
    final missingFields = <_ProfileTask>[];
    if (!hasFullName) {
      missingFields.add(const _ProfileTask(
        key: 'full_name',
        icon: Icons.person_outline_rounded,
        label: 'Isi nama depan, tengah & belakang Anda',
        action: 'Isi',
        section: 'name',
      ));
    }
    if (items['username'] == false) {
      missingFields.add(const _ProfileTask(
        key: 'username',
        icon: Icons.alternate_email_rounded,
        label: 'Buat username unik Anda',
        action: 'Buat',
        section: 'username',
      ));
    }
    if (items['avatar_url'] == false) {
      missingFields.add(const _ProfileTask(
        key: 'avatar_url',
        icon: Icons.account_circle_outlined,
        label: 'Unggah foto profil Anda',
        action: 'Unggah',
        section: 'avatar',
      ));
    }
    if (items['whatsapp'] == false) {
      missingFields.add(const _ProfileTask(
        key: 'whatsapp',
        icon: Icons.phone_outlined,
        label: 'Tambahkan nomor WhatsApp aktif',
        action: 'Tambah',
        section: 'whatsapp',
      ));
    }
    if (items['email_verified'] == false) {
      missingFields.add(const _ProfileTask(
        key: 'email_verified',
        icon: Icons.mark_email_unread_outlined,
        label: 'Verifikasi alamat email Anda',
        action: 'Verifikasi',
        section: 'username',
      ));
    }
    if (items['nik'] == false) {
      missingFields.add(const _ProfileTask(
        key: 'nik',
        icon: Icons.badge_outlined,
        label: 'Nomor Identitas (NIK / Passport / SIM / NPWP)',
        action: 'Isi',
        section: 'identity',
      ));
    }

    // --- Cek field dari userData langsung (tidak ada di completionItems backend) ---
    final identityVerified = userData?['identity_verified_at'] != null;
    // Hanya tampilkan field identitas & alamat jika identitas belum terverifikasi
    if (!identityVerified) {
      final birthPlace = (userData?['birth_place'] as String? ?? '').trim();
      if (birthPlace.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'birth_place',
          icon: Icons.location_city_outlined,
          label: 'Isi tempat lahir Anda',
          action: 'Isi',
          section: 'identity',
        ));
      }

      final birthDate = (userData?['birth_date'] as String? ?? '').trim();
      if (birthDate.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'birth_date',
          icon: Icons.cake_outlined,
          label: 'Isi tanggal lahir Anda',
          action: 'Isi',
          section: 'identity',
        ));
      }

      final country = (userData?['country'] as String? ?? '').trim();
      if (country.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'country',
          icon: Icons.flag_outlined,
          label: 'Pilih negara tempat tinggal Anda',
          action: 'Pilih',
          section: 'identity',
        ));
      }

      final provinceName = (userData?['province_name'] as String? ?? '').trim();
      if (provinceName.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'province',
          icon: Icons.map_outlined,
          label: 'Pilih provinsi tempat tinggal Anda',
          action: 'Pilih',
          section: 'identity',
        ));
      }

      final cityName = (userData?['city_name'] as String? ?? '').trim();
      if (cityName.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'city',
          icon: Icons.location_on_outlined,
          label: 'Pilih kota / kabupaten Anda',
          action: 'Pilih',
          section: 'identity',
        ));
      }

      final districtName = (userData?['district_name'] as String? ?? '').trim();
      if (districtName.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'district',
          icon: Icons.holiday_village_outlined,
          label: 'Pilih kecamatan Anda',
          action: 'Pilih',
          section: 'identity',
        ));
      }

      final villageName = (userData?['village_name'] as String? ?? '').trim();
      if (villageName.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'village',
          icon: Icons.home_work_outlined,
          label: 'Pilih kelurahan / desa Anda',
          action: 'Pilih',
          section: 'identity',
        ));
      }

      final postalCode = (userData?['postal_code'] as String? ?? '').trim();
      if (postalCode.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'postal_code',
          icon: Icons.markunread_mailbox_outlined,
          label: 'Isi kode pos wilayah Anda',
          action: 'Isi',
          section: 'identity',
        ));
      }

      final address = (userData?['address'] as String? ?? '').trim();
      if (address.isEmpty) {
        missingFields.add(const _ProfileTask(
          key: 'address',
          icon: Icons.edit_road_outlined,
          label: 'Isi detail alamat lengkap Anda',
          action: 'Isi',
          section: 'identity',
        ));
      }
    }

    if (items['ktp_photo'] == false) {
      missingFields.add(const _ProfileTask(
        key: 'ktp_photo',
        icon: Icons.credit_card_outlined,
        label: 'Unggah Foto KTP / Passport / SIM / NPWP',
        action: 'Unggah',
        section: 'ktp_photo',
      ));
    }
    if (items['selfie_photo'] == false) {
      missingFields.add(const _ProfileTask(
        key: 'selfie_photo',
        icon: Icons.face_outlined,
        label: 'Unggah Foto Selfie + Dokumen Identitas (KTP/Passport/SIM/NPWP)',
        action: 'Unggah',
        section: 'selfie',
      ));
    }
    if (items['identity_verified'] == false) {
      missingFields.add(const _ProfileTask(
        key: 'identity_verified',
        icon: Icons.face_retouching_natural,
        label: 'Verifikasi wajah dengan scan selfie Anda',
        action: 'Scan',
        section: 'selfie',
      ));
    }

    // Jika semua data sudah lengkap, sembunyikan card sepenuhnya
    if (missingFields.isEmpty) return const SizedBox.shrink();

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kelengkapan Profil', style: AppTextStyles.titleSmall),
                  Text(
                    '$percent%',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: percent >= 80
                          ? Colors.green
                          : (percent >= 50 ? Colors.orange : AppColors.primaryColor),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 10,
                  backgroundColor: AppColors.secondaryColor.withAlpha(50),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percent >= 80
                        ? Colors.green
                        : (percent >= 50 ? Colors.orange : AppColors.primaryColor),
                  ),
                ),
              ),
              if (missingFields.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF888888)),
                    const SizedBox(width: 6),
                    Text(
                      '${missingFields.length} data belum dilengkapi',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...missingFields.map((task) => _buildTaskRow(task)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTask(_ProfileTask task) async {
    switch (task.key) {

      case 'email_verified':
        // Kirim OTP → halaman verifikasi OTP
        final userData = ref.read(profileProvider).userData;
        final email = userData?['email'] as String?;
        if (email == null || email.isEmpty) {
          AppSnackBar.show(context, 'Email belum diisi di profil', type: SnackBarType.warning);
          return;
        }
        try {
          await ref.read(profileProvider.notifier).sendVerifyEmailOtp(email);
          if (mounted) {
            context.push('/verify-otp', extra: {'email': email, 'purpose': 'verify_email'});
          }
        } catch (e) {
          if (mounted) {
            AppSnackBar.show(context, 'Gagal mengirim OTP verifikasi. Coba lagi.', type: SnackBarType.error);
          }
        }
        break;

      case 'identity_verified':
        // Verifikasi wajah → Face Scanner
        context.push('/face-scanner');
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
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
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
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
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


  Widget _buildIdentityVerification(Map<String, dynamic>? userData) {
    final identityVerified = userData?['identity_verified_at'] != null;
    final selfieUrl = userData?['selfie_photo_url'] as String?;

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
                      color: identityVerified ? Colors.green.withAlpha(25) : Colors.orange.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      identityVerified ? Icons.verified : Icons.warning_amber_rounded,
                      color: identityVerified ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          identityVerified ? 'Identitas Terverifikasi' : 'Identitas Belum Terverifikasi',
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
                                  'Verifikasi Wajah',
                                  style: AppTextStyles.bodySmall.copyWith(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: AppSizes.sm),
                  TextButton.icon(
                    onPressed: () => context.push('/face-scanner'),
                    icon: Icon(
                      identityVerified ? Icons.refresh : Icons.camera_alt_outlined,
                      size: 16,
                    ),
                    label: Text(
                      identityVerified ? 'Verifikasi Ulang Wajah' : 'Verifikasi Sekarang',
                      style: AppTextStyles.bodySmall,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: identityVerified ? AppColors.primaryColor : Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
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
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
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

