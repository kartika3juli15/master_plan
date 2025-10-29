import 'package:flutter/material.dart';

class Task {
  final String description;
  final bool complete;

  const Task({this.description = '', this.complete = false});
}

class Plan {
  final String name;
  final List<Task> tasks;

  const Plan({this.name = '', this.tasks = const []});

  String get completenessMessage {
    if (tasks.isEmpty) {
      return 'No tasks yet';
    }
    final completed = tasks.where((task) => task.complete).length;
    return '$completed out of ${tasks.length} tasks completed';
  }
}

// Provider untuk membagikan state Plan ke seluruh widget
class PlanProvider extends InheritedNotifier<ValueNotifier<Plan>> {
  const PlanProvider({
    super.key,
    required ValueNotifier<Plan> notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  // Digunakan untuk mengakses PlanProvider dari context
  static ValueNotifier<Plan> of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<PlanProvider>();
    assert(provider != null, 'No PlanProvider found in context');
    return provider!.notifier!;
  }
}
