import 'package:flutter/material.dart';
import '../../data/models/debt_model.dart';
import '../../data/repositories/debt_repository.dart';
import '../theme/app_colors.dart';

class DebtDetailScreen extends StatefulWidget {
  final int debtId;

  const DebtDetailScreen({super.key, required this.debtId});

  @override
  State<DebtDetailScreen> createState() => _DebtDetailScreenState();
}

class _DebtDetailScreenState extends State<DebtDetailScreen> {
  final _debtRepository = DebtRepository();
  DebtModel? _debt;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDebt();
  }

  Future<void> _loadDebt() async {
    try {
      final debt = await _debtRepository.getDebt(widget.debtId);
      setState(() {
        _debt = debt;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('데이터 로드 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '거래 상세',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _debt == null
              ? const Center(child: Text('데이터를 불러올 수 없습니다'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildDetailSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    final debt = _debt!;
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: debt.isLent
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              debt.isLent ? '빌려줌' : '빌림',
              style: TextStyle(
                color: debt.isLent ? AppColors.primary : AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${debt.isLent ? '+' : '-'}₩${_formatNumber(debt.amount)}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: debt.isLent ? AppColors.primary : AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: debt.isSettled
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              debt.isSettled ? '정산완료' : '미정산',
              style: TextStyle(
                fontSize: 13,
                color: debt.isSettled ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection() {
    final debt = _debt!;
    final date = '${debt.transactionDate.year}.${debt.transactionDate.month.toString().padLeft(2, '0')}.${debt.transactionDate.day.toString().padLeft(2, '0')}';

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '상세 정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('상대방', debt.profileName ?? '알 수 없음'),
          _buildDetailRow('거래일', date),
          if (debt.category != null) _buildDetailRow('카테고리', debt.category!),
          if (debt.memo != null) _buildDetailRow('메모', debt.memo!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
