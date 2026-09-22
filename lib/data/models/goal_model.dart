import 'package:isar/isar.dart';

part 'goal_model.g.dart';

@collection
class GoalModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String type; // 'daily', 'weekly', 'monthly'
  late String goalType; // 'study_hours', 'tasks_completed'

  double targetValue = 0.0;
  double currentValue = 0.0;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 7));

  bool isCompleted = false;
}
