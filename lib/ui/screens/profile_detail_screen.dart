import 'package:flutter/material.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';
import '../theme/app_colors.dart';
import 'add_repayment_screen.dart';
import 'edit_profile_screen.dart';

class ProfileDetailScreen extends StatefulWidget {
  final int profileId;
  final String name;

  const ProfileDetailScreen({
    super.key,
    required this.profileId,
    required this.name,
  });

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final _profileRepository = ProfileRepository();
  ProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileRepository.getProfile(widget.profileId);
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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
        title: Text(
          _profile?.name ?? widget.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
            onPressed: _profile != null
                ? () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(profile: _profile!),
                      ),
                    );
                    if (result == true) {
                      _loadProfile();
                    }
                  }
                : null,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 16),
                  if (_profile?.memo != null && _profile!.memo!.isNotEmpty)
                    _buildMemoSection(),
                  _buildTransactionSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              (_profile?.name ?? widget.name)[0],
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _profile?.name ?? widget.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            [_profile?.relation, _profile?.organization]
                .where((e) => e != null && e.isNotEmpty)
                .join(' · '),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          if (_profile?.phone != null && _profile!.phone!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              _profile!.phone!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  '받을 돈',
                  '₩${_formatNumber(_profile?.totalLent ?? 0)}',
                  AppColors.primary,
                ),
                Container(width: 1, height: 40, color: AppColors.border),
                _buildSummaryItem(
                  '갚을 돈',
                  '₩${_formatNumber(_profile?.totalBorrowed ?? 0)}',
                  AppColors.error,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoSection() {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '메모',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _profile!.memo!,
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '거래 내역',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddRepaymentScreen(
                        profileId: widget.profileId,
                        profileName: _profile?.name ?? widget.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('상환 등록'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                '거래 내역이 없습니다',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(amount, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
