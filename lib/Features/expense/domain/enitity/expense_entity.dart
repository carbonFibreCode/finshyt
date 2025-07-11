class ExpenseEntity {
  final String id;
  final double amount;
  final String purpose;
  final DateTime ts;

  const ExpenseEntity({
    required this.id,
    required this.amount,
    required this.purpose,
    required this.ts,
  });
}