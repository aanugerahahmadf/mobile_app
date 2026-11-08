import '../../Data/Models/VoucherModel/VoucherModel.dart';

abstract class VoucherRepository {
  Future<List<VoucherModel>> getVouchers();
  Future<bool> claimVoucher(String id);
}
