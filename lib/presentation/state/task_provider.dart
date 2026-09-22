import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/task_model.dart';
import '../../data/storage/isar_service.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  // This is usually provided at the top level, but for simplicity we use a singleton here
  // In a real app, we'd inject the initialized isar instance.
  throw UnimplementedError('Use the one in main.dart or a singleton');
});

// To fix the main.dart provider conflict, I'll define the actual logic providers here
final tasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final isar = Isar.getInstance()!;
  return isar.taskModels.where().watch(fireImmediately: true).map((tasks) => tasks.toList());
});

class TaskNotifier extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final Isar isar;
  TaskNotifier(this.isar) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    state = AsyncValue.data(await isar.taskModels.where().findAll());
  }

  Future<void> addTask(TaskModel task) async {
    await isar.writeTxn(() async {
      await isar.taskModels.put(task);
    });
    state = AsyncValue.data(await isar.taskModels.where().findAll());
  }

  Future<void> toggleTask(int id) async {
    await isar.writeTxn(() async {
      final task = await isar.taskModels.get(id);
      if (task != null) {
        task.isCompleted = !task.isCompleted;
        await isar.taskModels.put(task);
      }
    });
    state = AsyncValue.data(await isar.taskModels.where().findAll());
  }

  Future<void> deleteTask(int id) async {
    await isar.writeTxn(() async {
      await isar.taskModels.delete(id);
    });
    state = AsyncValue.data(await isar.taskModels.where().findAll());
  }
}

final taskNotifierProvider = StateNotifierProvider<TaskNotifier, AsyncValue<List<TaskModel>>>((ref) {
  final isar = Isar.getInstance()!;
  return TaskNotifier(isar);
});
