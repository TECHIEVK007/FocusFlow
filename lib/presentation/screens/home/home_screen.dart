import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus_flow/core/theme/app_theme.dart';
import 'package:focus_flow/presentation/state/task_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Focus Hub',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.darkPrimary,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader(context, 'Upcoming Deadlines'),
                    const SizedBox(height: 16),
                    tasksAsync.when(
                      data: (tasks) {
                        final upcoming = tasks.where((t) => !t.isCompleted).toList();
                        if (upcoming.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text('No upcoming deadlines! 🎉'),
                            ),
                          );
                        }
                        return Column(
                          children: upcoming.take(3).map((task) => _buildTaskCard(context, task)).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Text('Error: $err'),
                    ),
                    const SizedBox(height: 32),
                    _buildQuickActions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/create'),
        label: const Text('Quick Task'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(
          onPressed: () => context.push('/tasks'),
          child: const Text('See All'),
        ),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, dynamic task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.darkPrimary.withOpacity(0.2),
          child: Icon(Icons.circle, size: 12, color: AppColors.darkPrimary),
        ),
        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(task.subject),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/tasks/${task.id}'),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionButton(context, Icons.timer, 'Study', '/study'),
        _actionButton(context, Icons.note, 'Notes', '/notes'),
        _actionButton(context, Icons.track_changes, 'Goals', '/goals'),
        _actionButton(context, Icons.analytics, 'Stats', '/analytics'),
      ],
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label, String path) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.darkSurface,
          child: IconButton(
            icon: Icon(icon, color: AppColors.darkPrimary),
            onPressed: () => context.push(path),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
