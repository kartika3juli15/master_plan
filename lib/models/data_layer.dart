import 'package:flutter/material.dart';

class Task {
  final String description;
  final bool complete;

  const Task({this.description = '', this.complete = false});
}

class Plan {
  final String name;
  final List<Task> tasks;

  const Plan({required this.name, required this.tasks});

  String get completenessMessage {
    if (tasks.isEmpty) return 'Tidak ada tugas';
    final completed = tasks.where((task) => task.complete).length;
    return '$completed dari ${tasks.length} tugas selesai';
  }
}
