abstract class ProfileRepository {
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data);
  Future<String> uploadAvatar(String filePath);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> updateDocumentNumber(
    String ktpNumber, {
    String documentType = 'ktp',
  });
  Future<Map<String, dynamic>> uploadDocument(
    String filePath, {
    String documentType = 'ktp',
  });
  Future<Map<String, dynamic>> uploadSelfie(
    String filePath, {
    bool livenessCompleted = false,
  });
  Future<Map<String, dynamic>> uploadFaceScan(
    String filePath, {
    bool livenessCompleted = false,
  });
  Future<Map<String, dynamic>> getCompletion();
}
