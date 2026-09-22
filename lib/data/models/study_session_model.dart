import 'package:isar/isar.dart';

part 'study_session_model.g.dart';

@collection
class StudySessionModel {
  Id id = Isar.autoIncrement;

  late String subject;
  late DateTime startTime;
  late DateTime endTime;
  late int durationMinutes;
  
  String? note;
  
  DateTime createdAt = DateTime.now();
}
