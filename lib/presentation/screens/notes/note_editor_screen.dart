import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:focus_flow/core/theme/app_theme.dart';
import 'package:focus_flow/presentation/state/note_provider.dart';
import 'package:focus_flow/data/models/note_model.dart';
import 'dart:io';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final int? noteId;
  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedSubject = 'General';
  List<String> _attachments = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  void _loadNote() {
    if (widget.noteId != null) {
      final notes = ref.read(notesProvider).value;
      if (notes != null) {
        final note = notes.firstWhere((n) => n.id == widget.noteId, orElse: () => NoteModel()..title = '');
        _titleController.text = note.title;
        _contentController.text = note.content;
        _selectedSubject = note.subject;
        _attachments = List.from(note.attachments);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _attachments.add(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _saveNote() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final note = NoteModel()
      ..title = _titleController.text
      ..content = _contentController.text
      ..subject = _selectedSubject
      ..category = 'General'
      ..attachments = _attachments;

    if (widget.noteId != null) {
      note.id = widget.noteId!;
    }

    ref.read(noteNotifierProvider.notifier).addNote(note);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'New Note' : 'Edit Note'),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
              maxLines: 10,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Subject: $_selectedSubject', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                DropdownButton<String>(
                  value: _selectedSubject,
                  items: ['General', 'Academic', 'Personal', 'Health'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) => setState(() => _selectedSubject = val!),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Attachments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo_library),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      tooltip: 'Gallery',
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () => _pickImage(ImageSource.camera),
                      tooltip: 'Camera',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _attachments.map((path) => _buildAttachmentThumbnail(path)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentThumbnail(String path) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(path),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () => _removeAttachment(_attachments.indexOf(path)),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
