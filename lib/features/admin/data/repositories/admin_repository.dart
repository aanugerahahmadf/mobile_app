import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/admin_remote_datasource.dart';

class AdminRepository {
  final AdminRemoteDataSource _dataSource;

  AdminRepository(this._dataSource);

  Future<List<Map<String, dynamic>>> list(String endpoint) => _dataSource.list(endpoint);
  Future<Map<String, dynamic>?> show(String Function(int id) endpoint, int id) => _dataSource.show(endpoint, id);
  Future<Map<String, dynamic>?> create(String endpoint, Map<String, dynamic> data) => _dataSource.create(endpoint, data);
  Future<void> update(String Function(int id) endpoint, int id, Map<String, dynamic> data) => _dataSource.update(endpoint, id, data);
  Future<void> delete(String Function(int id) endpoint, int id) => _dataSource.delete(endpoint, id);
  Future<void> uploadImage(String Function(int id) endpoint, int id, String filePath) => _dataSource.uploadImage(endpoint, id, filePath);
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) => AdminRepository(AdminRemoteDataSource()));
