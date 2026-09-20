import '../../data/models/voucher_model/voucher_model.dart';

abstract class VoucherRepository {
  Future<List<VoucherModel>> getVouchers();
  Future<bool> claimVoucher(String id);
}
