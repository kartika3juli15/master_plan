import 'package:flutter/material.dart';
import '../models/data_layer.dart';

class PlanProvider extends InheritedNotifier<ValueNotifier<List<Plan>>> {
  const PlanProvider({
    super.key,
    required ValueNotifier<List<Plan>> notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static ValueNotifier<List<Plan>> of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<PlanProvider>();
    assert(provider != null, 'No PlanProvider found in context');
    return provider!.notifier!;
  }
}
