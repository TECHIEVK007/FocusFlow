import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus_flow/core/theme/app_theme.dart';
import 'package:focus_flow/presentation/state/study_provider.dart';
import 'package:focus_flow/data/models/study_session_model.dart';
import 'dart:async';

class StudyTimerScreen extends ConsumerStatefulWidget {
  const StudyTimerScreen({super.key});

  @override
  ConsumerState<StudyTimerScreen> createState() => _StudyTimerScreenState();
}

class _StudyTimerScreenState extends ConsumerState<StudyTimerScreen> {
  Timer? _timer;
  int _secondsRemaining = 25 * 60;
  bool _isRunning = false;
  String _selectedSubject = 'General';
  
  final List<String> _subjects = ['General', 'Mathematics', 'Physics', 'Computer Science', 'History', 'English'];

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopTimer(completed: true);
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() => _isRunning = false);
    _timer?.cancel();
  }

  void _stopTimer({bool completed = false}) {
    setState(() {
      _isRunning = false;
      if (!completed) _secondsRemaining = 25 * 60;
    });
    _timer?.cancel();
    
    if (completed) {
      _saveSession();
    }
  }

  void _saveSession() {
    final session = StudySessionModel()
      ..subject = _selectedSubject
      ..startTime = DateTime.now().subtract(Duration(minutes: 25))
      ..endTime = DateTime.now()
      ..durationMinutes = 25;
    
    ref.read(studyNotifierProvider.notifier).addSession(session);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Study session saved!')),
    );
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedSubject,
              items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _selectedSubject = val!),
            ),
            const SizedBox(height: 48),
            Text(
              _formatTime(_secondsRemaining),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 80),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('START'),
                  )
                else
                  ElevatedButton(
                    onPressed: _pauseTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('PAUSE'),
                  ),
                const SizedBox(width: 24),
                OutlinedButton(
                  onPressed: () => _stopTimer(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('RESET'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
