class Transaction {
  final String id;
  final String name;
  final double amount;
  final String categoryId;
  final bool isIncome;
  final DateTime date;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.categoryId,
    required this.isIncome, required this.date,
  });
}
