import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:focus_flow/data/models/task_model.dart';
import 'package:focus_flow/data/models/study_session_model.dart';
import 'package:focus_flow/data/models/note_model.dart';
import 'package:focus_flow/data/models/goal_model.dart';

class IsarService {
  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        TaskModelSchema,
        StudySessionModelSchema,
        NoteModelSchema,
        GoalModelSchema,
      ],
      directory: dir.path,
    );
  }

  // Generic helper for CRUD
  Future<void> save<T extends IsarCollection>(T collection, T item) async {
    await isar.writeTxn(() async {
      await collection.put(item);
    });
  }

  Future<void> delete<T extends IsarCollection>(T collection, int id) async {
    await isar.writeTxn(() async {
      await collection.delete(id);
    });
  }
}
