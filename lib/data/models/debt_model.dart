class DebtModel {
  final int id;
  final int profileId;
  final String? profileName;
  final int amount;
  final DateTime transactionDate;
  final String? category;
  final String? memo;
  final String transactionType; // "lent" | "borrowed"
  final bool isSettled;

  DebtModel({
    required this.id,
    required this.profileId,
    this.profileName,
    required this.amount,
    required this.transactionDate,
    this.category,
    this.memo,
    required this.transactionType,
    this.isSettled = false,
  });

  bool get isLent => transactionType == 'lent';

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      profileId: json['profile_id'] is String ? int.parse(json['profile_id']) : json['profile_id'],
      profileName: json['profile_name'],
      amount: json['amount'] is String ? int.parse(json['amount']) : json['amount'],
      transactionDate: DateTime.parse(json['transaction_date']),
      category: json['category'],
      memo: json['memo'],
      transactionType: json['transaction_type'] ?? 'lent',
      isSettled: json['is_settled'] ?? false,
    );
  }
}
