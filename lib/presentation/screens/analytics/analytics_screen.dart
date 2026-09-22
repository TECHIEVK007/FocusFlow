import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focus_flow/presentation/state/task_provider.dart';
import 'package:focus_flow/presentation/state/study_provider.dart';
import 'package:focus_flow/presentation/state/goal_provider.dart';
import 'package:focus_flow/core/theme/app_theme.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final studyAsync = ref.watch(studySessionsProvider);
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard(context, 'Total Study Time', studyAsync.maybeWhen(
              data: (s) => '${s.fold<int>(0, (sum, item) => sum + item.durationMinutes)} mins',
              orElse: () => '0 mins',
            ), Icons.timer),
            const SizedBox(height: 16),
            _buildStatCard(context, 'Tasks Completed', tasksAsync.maybeWhen(
              data: (t) => '${t.where((task) => task.isCompleted).length}',
              orElse: () => '0',
            ), Icons.check_circle),
            const SizedBox(height: 32),
            Text('Study Trends', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: studyAsync.when(
                data: (sessions) => _buildStudyChart(sessions),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Error: $e'),
              ),
            ),
            const SizedBox(height: 32),
            Text('Goal Progress', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            goalsAsync.when(
              data: (goals) => Column(
                children: goals.map((g) => _buildGoalProgressRow(context, g)).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.darkPrimary),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStudyChart(List sessions) {
    // Simplified chart for demo purposes, in real app we'd group by date
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(2, 2),
              FlSpot(3, 5),
              FlSpot(4, 4),
            ],
            isCurved: true,
            color: AppColors.darkPrimary,
            barWidth: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgressRow(BuildContext context, dynamic goal) {
    final progress = (goal.currentValue / goal.targetValue).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goal.title),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: progress, backgroundColor: AppColors.darkSurface, color: AppColors.darkPrimary),
        ],
      ),
    );
  }
}
