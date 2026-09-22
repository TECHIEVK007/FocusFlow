import 'package:isar/isar.dart';

part 'note_model.g.dart';

@collection
class NoteModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;
  late String subject;
  late String category;
  
  List<String> attachments = [];
  List<int> linkedTaskIds = [];
  
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
