import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/router.dart';
import 'core/utils/notification_service.dart';
import 'data/storage/isar_service.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  throw UnimplementedError('IsarService should be accessed via the singleton instance initialized in main');
});

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Isar
  final isarService = IsarService();
  await isarService.init();
  
  // Initialize Notifications
  await NotificationService().init();
}

void main() async {
  await setupApp();
  
  runApp(
    const ProviderScope(
      child: FocusFlowApp(),
    ),
  );
}

class FocusFlowApp extends ConsumerWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'FocusFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
