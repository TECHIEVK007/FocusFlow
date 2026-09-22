import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus_flow/core/theme/app_theme.dart';
import 'package:focus_flow/presentation/state/task_provider.dart';
import 'package:focus_flow/data/models/task_model.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final String taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
      data: (tasks) {
        final task = tasks.firstWhere((t) => t.id.toString() == taskId);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Task Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
                  context.pop();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                Chip(label: Text(task.subject), backgroundColor: AppColors.darkPrimary.withOpacity(0.2)),
                const SizedBox(height: 24),
                Text('Description', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(task.description ?? 'No description provided.', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                Text('Category: ${task.category}', style: Theme.of(context).textTheme.bodyMedium),
                Text('Priority: ${task.priority == 3 ? 'High' : task.priority == 2 ? 'Medium' : 'Low'}', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
