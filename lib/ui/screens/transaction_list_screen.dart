import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          '거래내역',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildTransactionItem(
            name: ['김철수', '이지은', '박지민', '최준호', '정민수'][index % 5],
            date: '2023.10.${24 - index}',
            memo: ['점심값', '택시비', '생일선물', '카페', '영화'][index % 5],
            amount: [12000, 5500, 50000, 15000, 25000][index % 5],
            isSettled: index % 3 == 0,
            isLent: index % 2 == 0,
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem({
    required String name,
    required String date,
    required String memo,
    required int amount,
    required bool isSettled,
    required bool isLent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              name[0],
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isLent ? AppColors.primary.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isLent ? '빌려줌' : '빌림',
                        style: TextStyle(
                          fontSize: 10,
                          color: isLent ? AppColors.primary : AppColors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$date · $memo',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isLent ? '+' : '-'}₩${_formatNumber(amount)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isLent ? AppColors.primary : AppColors.error,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSettled ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isSettled ? '정산완료' : '미정산',
                  style: TextStyle(
                    fontSize: 11,
                    color: isSettled ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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
