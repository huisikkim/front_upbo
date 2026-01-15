import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'add_profile_screen.dart';
import 'profile_detail_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          '친구',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined, color: AppColors.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          return _buildContactItem(
            context,
            name: ['김철수', '이지은', '박지민', '최준호', '정민수', '한소희', '강동원', '송혜교'][index],
            relationship: ['친구', '동료', '가족', '친구', '선배', '동료', '후배', '친구'][index],
            organization: ['삼성전자', 'LG전자', '-', '네이버', '카카오', 'SK', '현대', '구글'][index],
            totalDebt: [120000, -55000, 500000, 0, -150000, 80000, 0, 230000][index],
          );
        },
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required String name,
    required String relationship,
    required String organization,
    required int totalDebt,
  }) {
    final isPositive = totalDebt >= 0;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfileDetailScreen(name: name)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                name[0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$relationship · $organization',
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
                if (totalDebt != 0) ...[
                  Text(
                    '${isPositive ? '+' : ''}₩${_formatNumber(totalDebt.abs())}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? AppColors.primary : AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isPositive ? '받을 돈' : '갚을 돈',
                    style: TextStyle(
                      fontSize: 11,
                      color: isPositive ? AppColors.primary : AppColors.error,
                    ),
                  ),
                ] else
                  const Text(
                    '정산 완료',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
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
