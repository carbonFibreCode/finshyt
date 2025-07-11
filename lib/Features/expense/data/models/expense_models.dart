
class ExpenseItem {
  final String id;
  final double amount;
  final String purpose;
  final DateTime ts;

  ExpenseItem({
    required this.id,
    required this.amount,
    required this.purpose,
    required this.ts,
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) => ExpenseItem(
        id:      json['id']          as String,
        amount:  (json['amount']     as num).toDouble(),
        purpose: json['purpose']     as String,
        ts:      DateTime.parse(json['ts'] as String),
      );
}


