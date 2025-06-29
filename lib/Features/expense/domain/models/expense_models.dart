/// One day + its list of raw expenses
class DailyExpenseGroup {
  final DateTime date;                 
  final double total;              
  final List<ExpenseItem> items;       

  const DailyExpenseGroup({
    required this.date,
    required this.total,
    required this.items,
  });
}

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
