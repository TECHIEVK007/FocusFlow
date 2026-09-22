import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus_flow/core/theme/app_theme.dart';
import 'package:focus_flow/presentation/state/task_provider.dart';
import 'package:focus_flow/data/models/task_model.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _subjectController = TextEditingController();
  String _selectedCategory = 'General';
  int _selectedPriority = 2;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) return;

    final task = TaskModel()
      ..title = _titleController.text
      ..description = _descController.text
      ..subject = _subjectController.text.isEmpty ? 'General' : _subjectController.text
      ..category = _selectedCategory
      ..priority = _selectedPriority;

    ref.read(taskNotifierProvider.notifier).addTask(task);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: ['General', 'Academic', 'Personal', 'Health', 'Finance'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 20),
            const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _priorityOption(1, 'Low'),
                _priorityOption(2, 'Medium'),
                _priorityOption(3, 'High'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityOption(int val, String label) {
    final isSelected = _selectedPriority == val;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedPriority = val);
      },
    );
  }
}
