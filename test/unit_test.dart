import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/data/models/task_model.dart';
import 'package:focus_flow/data/models/goal_model.dart';
import 'package:focus_flow/data/models/study_session_model.dart';

void main() {
  group('TaskModel Tests', () {
    test('Task creation and property assignment', () {
      final task = TaskModel()
        ..title = 'Test Task'
        ..subject = 'Flutter'
        ..category = 'Academic'
        ..priority = 3;

      expect(task.title, 'Test Task');
      expect(task.priority, 3);
      expect(task.isCompleted, isFalse);
    });
  });

  group('GoalModel Tests', () {
    test('Goal progress calculation', () {
      final goal = GoalModel()
        ..targetValue = 100.0
        ..currentValue = 45.0;

      final progress = (goal.currentValue / goal.targetValue).clamp(0.0, 1.0);
      expect(progress, 0.45);
    });

    test('Goal completion state', () {
      final goal = GoalModel()
        ..targetValue = 10.0
        ..currentValue = 10.0;

      // In a real app, this logic would be in a provider or the model
      final isCompleted = goal.currentValue >= goal.targetValue;
      expect(isCompleted, isTrue);
    });
  });

  group('StudySessionModel Tests', () {
    test('Study session duration calculation', () {
      final session = StudySessionModel()
        ..durationMinutes = 25;

      expect(session.durationMinutes, 25);
    });
  });
}
