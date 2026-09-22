import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_flow/presentation/screens/home/home_screen.dart';
import 'package:focus_flow/presentation/screens/tasks/tasks_screen.dart';
import 'package:focus_flow/presentation/screens/tasks/task_details_screen.dart';
import 'package:focus_flow/presentation/screens/tasks/create_task_screen.dart';
import 'package:focus_flow/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:focus_flow/presentation/screens/profile/profile_setup_screen.dart';
import 'package:focus_flow/presentation/screens/study/study_timer_screen.dart';
import 'package:focus_flow/presentation/screens/notes/notes_screen.dart';
import 'package:focus_flow/presentation/screens/notes/note_editor_screen.dart';
import 'package:focus_flow/presentation/screens/goals/goals_screen.dart';
import 'package:focus_flow/presentation/screens/analytics/analytics_screen.dart';
import 'package:focus_flow/presentation/screens/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: '/tasks/create',
        builder: (context, state) => const CreateTaskScreen(),
      ),
      GoRoute(
        path: '/tasks/:taskId',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return TaskDetailsScreen(taskId: taskId);
        },
      ),
      GoRoute(
        path: '/study',
        builder: (context, state) => const StudyTimerScreen(),
      ),
      GoRoute(
        path: '/notes',
        builder: (context, state) => const NotesScreen(),
      ),
      GoRoute(
        path: '/notes/create',
        builder: (context, state) => const NoteEditorScreen(),
      ),
      GoRoute(
        path: '/notes/:noteId',
        builder: (context, state) {
          final noteId = int.tryParse(state.pathParameters['noteId']!) ?? 0;
          return NoteEditorScreen(noteId: noteId);
        },
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsScreen(),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
