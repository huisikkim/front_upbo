class DebtModel {
  final int id;
  final int profileId;
  final String profileName;
  final int amount;
  final DateTime date;
  final String? memo;
  final String? imageUrl;
  final bool isLent; // true: 빌려줌, false: 빌림
  final bool isSettled;
  final int remainingAmount;

  DebtModel({
    required this.id,
    required this.profileId,
    required this.profileName,
    required this.amount,
    required this.date,
    this.memo,
    this.imageUrl,
    required this.isLent,
    this.isSettled = false,
    this.remainingAmount = 0,
  });

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'],
      profileId: json['profile_id'],
      profileName: json['profile_name'] ?? '',
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      memo: json['memo'],
      imageUrl: json['image_url'],
      isLent: json['is_lent'] ?? true,
      isSettled: json['is_settled'] ?? false,
      remainingAmount: json['remaining_amount'] ?? 0,
    );
  }
}
