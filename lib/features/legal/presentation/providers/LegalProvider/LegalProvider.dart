import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Core/Providers/LocaleProvider/LocaleProvider.dart';
import '../../../Data/LegalRepositoryImpl/LegalRepositoryImpl.dart';
import '../../../Data/Models/LegalModel/LegalModel.dart';
import '../../../Domain/LegalRepository/LegalRepository.dart';

final legalRepositoryProvider = Provider<LegalRepository>((ref) {
  return LegalRepositoryImpl();
});

final privacyPolicyProvider = FutureProvider<LegalContent>((ref) {
  final locale = ref.watch(localeProvider);
  return ref
      .read(legalRepositoryProvider)
      .getPrivacyPolicy(locale: locale.languageCode);
});

final termsOfServiceProvider = FutureProvider<LegalContent>((ref) {
  final locale = ref.watch(localeProvider);
  return ref
      .read(legalRepositoryProvider)
      .getTermsOfService(locale: locale.languageCode);
});

final weddingDecorationPolicyProvider = FutureProvider<LegalContent>((ref) {
  final locale = ref.watch(localeProvider);
  return ref
      .read(legalRepositoryProvider)
      .getWeddingDecorationPolicy(locale: locale.languageCode);
});

final helpCenterProvider = FutureProvider<HelpModel>((ref) {
  final locale = ref.watch(localeProvider);
  return ref
      .read(legalRepositoryProvider)
      .getHelpCenter(locale: locale.languageCode);
});

final aboutProvider = FutureProvider<AboutModel>((ref) {
  final locale = ref.watch(localeProvider);
  return ref
      .read(legalRepositoryProvider)
      .getAbout(locale: locale.languageCode);
});
