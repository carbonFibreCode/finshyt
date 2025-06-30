import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:finshyt/Features/ai_budget_planning/data/remote_data_source.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';

const _systemPrompt = '''
You are a personal-finance planner.

Return ONE JSON object only, no markdown, obey this schema:
{
  "plan": [
    { "date":"YYYY-MM-DD", "day":"Mon", "category":"string", "amount":123.45 }
  ]
}
****All the below given points must be strictly followed to giving the desired plan****
• Generate 30 consecutive days starting today.
• Sum(amount) ≤ monthly_budget (follow this condition stricly).
• If user description provided → honour it.
• Else use history.
• If no history → use averages for the city.
→ *****if the user has entered the event date, consider it but plan the budget
 from the current date to next 30 days, not the 
 event date to next 30 days*****
→ try to plan for 3% less amount then the budget given
''';

final class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  BudgetRemoteDataSourceImpl(this._sb);
  final SupabaseClient _sb;

//maiking draft
  @override
  Future<BudgetPlan> makeDraft({
    required String userId,
    required double monthlyBudget,
    required String description,
    required String city,
    required DateTime eventDate,
  }) async {
//fetch recent expenses
    final historyRows = await _sb
        .from('expenses')
        .select()
        .eq('user_id', userId)
        .order('ts', ascending: false)
        .limit(60);

//build plain-string message list
    final userPrompt =
        '''
monthly_budget : $monthlyBudget
city           : $city
description    : ${description.isEmpty ? 'N/A' : description}
history        : ${jsonEncode(historyRows)}
eventDate(consider the description for this date in general cases)      : $eventDate
''';

    final body = jsonEncode({
      'model': 'llama3-70b-8192',
      'messages': [
        {'role': 'system', 'content': _systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'response_format': {'type': 'json_object'},
      'temperature': 0.2,
      'seed': 42,
    });

//POST to Groq 
    final res = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['GROQ_KEY']!.trim()}',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (res.statusCode != 200) {
      throw Exception('Groq ${res.statusCode}: ${res.body.substring(0, 200)}');
    }

//extract assistant text 
    final content =
        jsonDecode(res.body)['choices'][0]['message']['content'] as String;

    if (!content.startsWith('{')) {
      throw Exception('Groq returned non-JSON: $content');
    }

    return BudgetPlan.fromJson(jsonDecode(content));
  }

//savePlan
  @override
  Future<void> savePlan({
    required String userId,
    required double dailyBudget,
    required BudgetPlan plan,
  }) async {
    final rows = plan.items
        .map(
          (i) => {
            'user_id': userId,
            'date': i.date.toIso8601String().substring(0, 10),
            'amount': i.amount, // per-day budget
          },
        )
        .toList();

    await _sb.from('daily_budget').upsert(rows);
  }
}
