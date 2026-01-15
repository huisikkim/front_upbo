import '../../core/constants/api_constants.dart';
import '../models/debt_model.dart';
import '../services/api_service.dart';

class DebtRepository {
  final _dio = ApiService.dio;

  Future<DebtModel> createDebt({
    required int profileId,
    required String transactionType,
    required int amount,
    String? category,
    String? memo,
    required DateTime transactionDate,
  }) async {
    final response = await _dio.post(
      ApiConstants.debts,
      data: {
        'profile_id': profileId,
        'transaction_type': transactionType,
        'amount': amount,
        'category': category,
        'memo': memo,
        'transaction_date': transactionDate.toUtc().toIso8601String(),
      },
    );
    return DebtModel.fromJson(response.data);
  }
}
