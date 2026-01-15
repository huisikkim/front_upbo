import '../../core/constants/api_constants.dart';
import '../models/repayment_model.dart';
import '../services/api_service.dart';

class RepaymentRepository {
  final _dio = ApiService.dio;

  /// 상환 등록
  Future<RepaymentModel> createRepayment({
    required int debtId,
    required int amount,
    required DateTime repaymentDate,
    String? memo,
  }) async {
    final response = await _dio.post(
      ApiConstants.repayments,
      data: {
        'debt_id': debtId,
        'amount': amount,
        'repayment_date': repaymentDate.toUtc().toIso8601String(),
        'memo': memo,
      },
    );
    return RepaymentModel.fromJson(response.data);
  }
}
