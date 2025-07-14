import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.userId,
    required super.startDate,
    required super.endDate,
    required super.createdAt,
    required List<BudgetItemModel> super.items,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      items: (json['budget_items'] as List<dynamic>? ?? [])
          .map((itemJson) => BudgetItemModel.fromJson(itemJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'items': items.map((item) => (item as BudgetItemModel).toJson()).toList(),
    };
  }
}

class BudgetItemModel extends BudgetItem {
  const BudgetItemModel({
    required super.id,
    required super.budgetId,
    required super.date,
    required super.amount,
  });

  factory BudgetItemModel.fromJson(Map<String, dynamic> json) {
    return BudgetItemModel(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budget_id': budgetId,
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }
}
