import 'package:flutter/material.dart';
import 'package:frontend/widgets/suggested_tag_widget.dart';

import 'package:provider/provider.dart';

import '../../models/note_model.dart';

import '../../providers/auth_provider.dart';

import '../../providers/notes_provider.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;

  late TextEditingController contentController;

  final tagController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late List<String> tags;

  late bool isPinned;

  late bool isArchived;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note.title);

    contentController = TextEditingController(text: widget.note.content);

    tags = List.from(widget.note.tags);

    isPinned = widget.note.isPinned;

    isArchived = widget.note.isArchived;
  }

  @override
  void dispose() {
    titleController.dispose();

    contentController.dispose();

    tagController.dispose();

    super.dispose();
  }

  Future<void> updateNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final token = context.read<AuthProvider>().token!;

    await context.read<NotesProvider>().updateNote(
      token: token,

      noteId: widget.note.id,

      title: titleController.text.trim(),

      content: contentController.text.trim(),

      tags: tags,

      isPinned: isPinned,

      isArchived: isArchived,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note updated')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NotesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isPinned = !isPinned;
              });
            },

            icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                isArchived = !isArchived;
              });
            },

            icon: Icon(isArchived ? Icons.archive : Icons.archive_outlined),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // TITLE
              TextFormField(
                controller: titleController,

                autofocus: true,

                maxLength: 25,

                decoration: const InputDecoration(hintText: 'Note title'),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // CONTENT
              TextFormField(
                controller: contentController,

                maxLines: 10,

                maxLength: 1000,

                decoration: const InputDecoration(
                  hintText: 'Write your note...',
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Content required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // TAG INPUT
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tagController,

                      decoration: const InputDecoration(hintText: 'Add tag'),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      final tag = tagController.text.trim();

                      if (tag.isNotEmpty && !tags.contains(tag)) {
                        setState(() {
                          tags.add(tag);
                        });

                        tagController.clear();
                      }
                    },

                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SuggestedTagsWidget(
                currentTags: tags,
                onTagSelected: (selectedTag) {
                  setState(() {
                    tags.add(selectedTag);
                  });
                },
              ),

              // TAGS
              Wrap(
                spacing: 8,

                children: tags.map((tag) {
                  return Chip(
                    label: Text(tag),

                    onDeleted: () {
                      setState(() {
                        tags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,

                height: 55,

                child: notesProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: updateNote,

                        child: const Text('Save Changes'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
