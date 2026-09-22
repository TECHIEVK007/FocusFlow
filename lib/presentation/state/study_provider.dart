import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/study_session_model.dart';

final studySessionsProvider = StreamProvider<List<StudySessionModel>>((ref) {
  final isar = Isar.getInstance()!;
  return isar.studySessionModels.where().watch(fireImmediately: true).map((sessions) => sessions.toList());
});

class StudyNotifier extends StateNotifier<AsyncValue<List<StudySessionModel>>> {
  final Isar isar;
  StudyNotifier(this.isar) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    state = AsyncValue.data(await isar.studySessionModels.where().findAll());
  }

  Future<void> addSession(StudySessionModel session) async {
    await isar.writeTxn(() async {
      await isar.studySessionModels.put(session);
    });
    state = AsyncValue.data(await isar.studySessionModels.where().findAll());
  }

  Future<void> deleteSession(int id) async {
    await isar.writeTxn(() async {
      await isar.studySessionModels.delete(id);
    });
    state = AsyncValue.data(await isar.studySessionModels.where().findAll());
  }
}

final studyNotifierProvider = StateNotifierProvider<StudyNotifier, AsyncValue<List<StudySessionModel>>>((ref) {
  final isar = Isar.getInstance()!;
  return StudyNotifier(isar);
});
