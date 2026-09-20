import '../../data/models/legal_model/legal_model.dart';

abstract class LegalRepository {
  Future<LegalContent> getPrivacyPolicy({String locale = 'id'});
  Future<LegalContent> getTermsOfService({String locale = 'id'});
  Future<LegalContent> getWeddingDecorationPolicy({String locale = 'id'});
  Future<HelpModel> getHelpCenter({String locale = 'id'});
  Future<AboutModel> getAbout({String locale = 'id'});
}
