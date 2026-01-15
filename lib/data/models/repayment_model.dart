class RepaymentModel {
  final int id;
  final int debtId;
  final int amount;
  final DateTime date;
  final int remainingDebt;

  RepaymentModel({
    required this.id,
    required this.debtId,
    required this.amount,
    required this.date,
    required this.remainingDebt,
  });

  factory RepaymentModel.fromJson(Map<String, dynamic> json) {
    return RepaymentModel(
      id: json['id'],
      debtId: json['debt_id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      remainingDebt: json['remaining_debt'],
    );
  }
}
