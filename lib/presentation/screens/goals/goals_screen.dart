import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus_flow/core/theme/app_theme.dart';
import 'package:focus_flow/presentation/state/goal_provider.dart';
import 'package:focus_flow/data/models/goal_model.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGoalDialog(context, ref),
          ),
        ],
      ),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return const Center(child: Text('No goals set. Set some and stay motivated!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              final progress = (goal.currentValue / goal.targetValue).clamp(0.0, 1.0);
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(goal.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          if (goal.isCompleted) const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.darkSurface,
                        color: AppColors.darkPrimary,
                        minHeight: 10,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${goal.currentValue} / ${goal.targetValue}', style: const TextStyle(fontSize: 14)),
                          Text('${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Goal Title')),
            TextField(controller: targetController, decoration: const InputDecoration(labelText: 'Target Value'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final goal = GoalModel()
                ..title = titleController.text
                ..type = 'monthly'
                ..goalType = 'study_hours'
                ..targetValue = double.tryParse(targetController.text) ?? 0
                ..currentValue = 0
                ..endDate = DateTime.now().add(const Duration(days: 30));
              ref.read(goalNotifierProvider.notifier).addGoal(goal);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
