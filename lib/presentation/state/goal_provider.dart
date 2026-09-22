import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/goal_model.dart';

final goalsProvider = StreamProvider<List<GoalModel>>((ref) {
  final isar = Isar.getInstance()!;
  return isar.goalModels.where().watch(fireImmediately: true).map((goals) => goals.toList());
});

class GoalNotifier extends StateNotifier<AsyncValue<List<GoalModel>>> {
  final Isar isar;
  GoalNotifier(this.isar) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    state = AsyncValue.data(await isar.goalModels.where().findAll());
  }

  Future<void> addGoal(GoalModel goal) async {
    await isar.writeTxn(() async {
      await isar.goalModels.put(goal);
    });
    state = AsyncValue.data(await isar.goalModels.where().findAll());
  }

  Future<void> updateProgress(int id, double value) async {
    await isar.writeTxn(() async {
      final goal = await isar.goalModels.get(id);
      if (goal != null) {
        goal.currentValue = value;
        if (goal.currentValue >= goal.targetValue) {
          goal.isCompleted = true;
        }
        await isar.goalModels.put(goal);
      }
    });
    state = AsyncValue.data(await isar.goalModels.where().findAll());
  }

  Future<void> deleteGoal(int id) async {
    await isar.writeTxn(() async {
      await isar.goalModels.delete(id);
    });
    state = AsyncValue.data(await isar.goalModels.where().findAll());
  }
}

final goalNotifierProvider = StateNotifierProvider<GoalNotifier, AsyncValue<List<GoalModel>>>((ref) {
  final isar = Isar.getInstance()!;
  return GoalNotifier(isar);
});
