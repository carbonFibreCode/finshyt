// lib/routes/route_generator.dart
import 'package:flutter/material.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/planning/planning_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case '/planning':
        final a = settings.arguments as Map;         
        return MaterialPageRoute(
          builder: (_) => PlanningScreen(
            userId        : a['userId']       as String,
            monthlyBudget : a['monthlyBudget'] as double,
            description   : a['description']  as String,
            eventDate     : a['eventDate']    as DateTime?,
            city          : a['city']         as String?,
          ),
        );


      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Unknown route: ${settings.name}')),
          ),
        );
    }
  }
}
