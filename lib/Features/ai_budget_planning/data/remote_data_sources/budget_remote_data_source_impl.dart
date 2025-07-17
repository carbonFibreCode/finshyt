import 'dart:convert';
import 'dart:developer';

import 'package:finshyt/Features/ai_budget_planning/data/remote_data_sources/budget_remote_data_source.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groq/groq.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final Groq _groq;

  BudgetRemoteDataSourceImpl(this._supabaseClient)
    : _groq = Groq(
        apiKey: dotenv.env['GROQ_API_KEY'] ?? '',
        model: 'llama3-70b-8192',
      ) {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (dotenv.env['GROQ_API_KEY'] == null ||
        dotenv.env['GROQ_API_KEY']!.isEmpty) {
      throw Exception(
        'GROQ_API_KEY not found in .env file. Please ensure it is set.',
      );
    }
    log(
      'Groq API initialized with key: ${apiKey!.substring(0, 5)}... (redacted)',
    );
    // Start a chat session when the data source is initialized.
    _groq.startChat();
  }

  /// Generates a budget plan using the Groq Cloud API with the Llama 3 70B model.
  @override
  Future<List<BudgetItem>> generateBudgetPlan({
    required double monthlyBudget,
    required String description,
    DateTime? eventDate,
    String? city,
  }) async {
    // A detailed system prompt to instruct the AI on its role and output format.
    final systemPrompt = '''
You are a financial planning assistant. Your task is to generate a 30-day daily budget plan based on the user's input.
The output MUST be a valid JSON object with a single key "plan" which contains an array of 30 objects. Each object must contain two keys: "date" (in "YYYY-MM-DD" format) and "amount" (as a number).
Do not include any introductory text, explanations, or code block markers in your response. Only output the raw JSON object.
''';

    // Set the instructions for this specific API call.
    _groq.setCustomInstructionsWith(systemPrompt);

    // Construct the user's request as a single, clear prompt.
    String userPrompt =
        'Generate a 30-day budget plan starting from ${eventDate?.subtract(const Duration(days: 15)).toIso8601String().substring(0, 10) ?? DateTime.now().toIso8601String().substring(0, 10)} '
        'for a total monthly budget of \$${monthlyBudget.toStringAsFixed(2)} for a user in ${city ?? "New Delhi"}.';
    userPrompt += '\nDescription of spending habits: "$description"';
    if (eventDate != null) {
      userPrompt +=
          '\nConsider a special event on this date: ${eventDate.toIso8601String().substring(0, 10)} and allocate extra budget around it.';
    }

    try {
      // Send the message to the Groq API.
      final GroqResponse response = await _groq.sendMessage(userPrompt);

      final content = response.choices.first.message.content;

      log('Groq API raw response: $content');

      final jsonResponse = jsonDecode(content) as Map<String, dynamic>;
      final planList = jsonResponse['plan'] as List<dynamic>;

      return planList.map((item) {
        final itemMap = item as Map<String, dynamic>;
        return BudgetItem(
          id: '',
          budgetId: '',
          date: DateTime.parse(itemMap['date'] as String),
          amount: (itemMap['amount'] as num).toDouble(),
        );
      }).toList();
    } on GroqException catch (e) {
      log('Groq API exception: ${e.message}');
      throw Exception('Groq API error: ${e.message}');
    } catch (e) {
      log('Budget plan generation error: $e');
      throw Exception('Failed to generate or parse budget plan: $e');
    }
  }

  /// Saves a complete budget plan to Supabase using a transactional function.
  @override
  Future<void> saveBudgetPlan({
    required String userId,
    required DateTime startDate,
    required List<BudgetItem> items,
  }) async {
    try {
      final List<Map<String, dynamic>> budgetItemsJson = items.map((item) {
        return {
          'date': item.date.toIso8601String().substring(0, 10),
          'amount': item.amount,
        };
      }).toList();
      log(
        'Calling RPC with params: userId=$userId, startDate=${startDate.toIso8601String().substring(0, 10)}, items=${budgetItemsJson.length}',
      );
      await _supabaseClient.rpc(
        'save_budget_plan_transaction',
        params: {
          'p_user_id': userId,
          'p_start_date': startDate.toIso8601String().substring(0, 10),
          'p_budget_items': budgetItemsJson,
        },
      );
    } on PostgrestException catch (e) {
      log('Supabase RPC error: ${e.message}, details: ${e.details}'); 
      throw Exception('Database error while saving plan: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while saving the plan: $e');
    }
  }
}
