class PlanItem {
  final DateTime date;
  final String   day;
  final double   amount;

  PlanItem({
    required this.date,
    required this.day,
    required this.amount,
  });

  factory PlanItem.fromJson(Map<String, dynamic> j) => PlanItem(
        date     : DateTime.parse(j['date'] as String),
        day      : j['day']      as String,
        amount   : (j['amount']  as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'date'    : date.toIso8601String(),
        'day'     : day,
        'amount'  : amount,
      };
}

class BudgetPlan {
  final List<PlanItem> items;
  const BudgetPlan(this.items);

  factory BudgetPlan.fromJson(Map<String, dynamic> j) =>
      BudgetPlan((j['plan'] as List).map((e) => PlanItem.fromJson(e)).toList());

  Map<String, dynamic> toJson() =>
      {'plan': items.map((e) => e.toJson()).toList()};
}
