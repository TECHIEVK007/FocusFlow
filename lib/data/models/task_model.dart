import 'package:isar/isar.dart';

part 'task_model.g.dart';

@collection
class TaskModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String title;
  
  String? description;
  late String subject;
  late String category;
  late int priority; // 1: Low, 2: Medium, 3: High
  
  DateTime? deadline;
  bool isCompleted = false;
  
  List<String> tags = [];
  DateTime createdAt = DateTime.now();
}
