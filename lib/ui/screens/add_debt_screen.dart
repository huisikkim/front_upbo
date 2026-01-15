import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  int _selectedType = 0; // 0: 빌려줌/도움줌, 1: 빌림/도움받음
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  final _targetController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSettled = false;

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '기록 추가',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              '저장',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 금액 입력
            Center(
              child: Column(
                children: [
                  const Text(
                    '거래 금액',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          decoration: const InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHint,
                            ),
                            border: InputBorder.none,
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const Text(
                        '원',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 타입 선택
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedType == 0 ? AppColors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedType == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          '빌려줌 / 도움줌',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedType == 0 ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedType == 1 ? AppColors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedType == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          '빌림 / 도움받음',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedType == 1 ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 대상
            _buildLabel('대상'),
            const SizedBox(height: 8),
            TextField(
              controller: _targetController,
              decoration: InputDecoration(
                hintText: '누구와 거래하셨나요?',
                hintStyle: const TextStyle(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.person_add_outlined, color: AppColors.textHint),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 거래일
            _buildLabel('거래일'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Icon(Icons.calendar_today_outlined, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 메모
            _buildLabel('메모 (선택)'),
            const SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '간단한 내용을 입력하세요',
                hintStyle: const TextStyle(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            // 정산 완료 토글
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '정산 완료',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '이미 정산이 끝난 기록인가요?',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isSettled,
                    onChanged: (value) => setState(() => _isSettled = value),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 저장 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}
