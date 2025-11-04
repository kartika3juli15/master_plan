import 'package:flutter/material.dart';
import '../models/data_layer.dart';
import '../provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({super.key, required this.plan});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          // Cari plan yang sesuai
          final currentPlanIndex = plans.indexWhere(
            (p) => p.name == widget.plan.name,
          );

          // Jika plan tidak ditemukan, tampilkan pesan error
          if (currentPlanIndex == -1) {
            return const Center(child: Text('Plan tidak ditemukan'));
          }

          final currentPlan = plans[currentPlanIndex];

          return Column(
            children: [
              Expanded(child: _buildList(currentPlan)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentPlan.completenessMessage,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        final plans = planNotifier.value;
        final planIndex = plans.indexWhere((p) => p.name == widget.plan.name);

        if (planIndex == -1) return;

        final currentPlan = plans[planIndex];
        final updatedTasks = List<Task>.from(currentPlan.tasks)
          ..add(const Task());

        final updatedPlans = List<Plan>.from(plans);
        updatedPlans[planIndex] = Plan(
          name: currentPlan.name,
          tasks: updatedTasks,
        );

        planNotifier.value = updatedPlans;
      },
    );
  }

  Widget _buildList(Plan plan) {
    if (plan.tasks.isEmpty) {
      return const Center(
        child: Text('Tidak ada task. Tekan tombol + untuk menambah task.'),
      );
    }

    return ListView.builder(
      controller: scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(plan.tasks[index], index, context),
    );
  }

  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          if (selected == null) return;

          final plans = planNotifier.value;
          final planIndex = plans.indexWhere((p) => p.name == widget.plan.name);

          if (planIndex == -1) return;

          final currentPlan = plans[planIndex];
          final updatedTasks = List<Task>.from(currentPlan.tasks);
          updatedTasks[index] = Task(
            description: task.description,
            complete: selected,
          );

          final updatedPlans = List<Plan>.from(plans);
          updatedPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

          planNotifier.value = updatedPlans;
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Tulis deskripsi task...',
        ),
        onChanged: (text) {
          final plans = planNotifier.value;
          final planIndex = plans.indexWhere((p) => p.name == widget.plan.name);

          if (planIndex == -1) return;

          final currentPlan = plans[planIndex];
          final updatedTasks = List<Task>.from(currentPlan.tasks);
          updatedTasks[index] = Task(
            description: text,
            complete: task.complete,
          );

          final updatedPlans = List<Plan>.from(plans);
          updatedPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

          planNotifier.value = updatedPlans;
        },
      ),
    );
  }
}
