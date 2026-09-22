import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/note_model.dart';

final notesProvider = StreamProvider<List<NoteModel>>((ref) {
  final isar = Isar.getInstance()!;
  return isar.noteModels.where().watch(fireImmediately: true).map((notes) => notes.toList());
});

class NoteNotifier extends StateNotifier<AsyncValue<List<NoteModel>>> {
  final Isar isar;
  NoteNotifier(this.isar) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    state = AsyncValue.data(await isar.noteModels.where().findAll());
  }

  Future<void> addNote(NoteModel note) async {
    await isar.writeTxn(() async {
      await isar.noteModels.put(note);
    });
    state = AsyncValue.data(await isar.noteModels.where().findAll());
  }

  Future<void> updateNote(NoteModel note) async {
    await isar.writeTxn(() async {
      await isar.noteModels.put(note);
    });
    state = AsyncValue.data(await isar.noteModels.where().findAll());
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      await isar.noteModels.delete(id);
    });
    state = AsyncValue.data(await isar.noteModels.where().findAll());
  }
}

final noteNotifierProvider = StateNotifierProvider<NoteNotifier, AsyncValue<List<NoteModel>>>((ref) {
  final isar = Isar.getInstance()!;
  return NoteNotifier(isar);
});
