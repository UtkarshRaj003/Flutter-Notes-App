import 'package:flutter/material.dart';
import 'package:frontend/widgets/suggested_tag_widget.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../../providers/notes_provider.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleController = TextEditingController();

  final contentController = TextEditingController();

  final tagController = TextEditingController();

  final List<String> tags = [];

  bool isPinned = false;

  bool isArchived = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // FIX 2: Memory leak se bachne ke liye controllers dispose kiye
    titleController.dispose();
    contentController.dispose();
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NotesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Note'),
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Form(
              key: _formKey,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TITLE
                  TextFormField(
                    controller: titleController,
                    autofocus: true,
                    maxLength: 25,

                    decoration: const InputDecoration(hintText: 'Title'),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title required';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // CONTENT
                  TextFormField(
                    controller: contentController,

                    maxLines: 6,
                    maxLength: 1000,

                    decoration: const InputDecoration(hintText: 'Content'),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Content required';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // TAG INPUT
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tagController,

                          decoration: const InputDecoration(
                            hintText: 'Add tag',
                          ),
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

                  const SizedBox(height: 10),

                  SuggestedTagsWidget(
                    currentTags: tags,
                    onTagSelected: (selectedTag) {
                      setState(() {
                        tags.add(selectedTag);
                      });
                    },
                  ),

                  // TAGS UI
                  Wrap(
                    spacing: 6,

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

                  const SizedBox(height: 24),

                  // SAVE BUTTON
                  notesProvider.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final token = context.read<AuthProvider>().token!;

                              await context.read<NotesProvider>().createNote(
                                token: token,

                                title: titleController.text.trim(),

                                content: contentController.text.trim(),

                                tags: tags,

                                isPinned: isPinned,

                                isArchived: isArchived,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Note created')),
                              );

                              Navigator.pop(context);
                            }
                          },

                          child: const Text('Save'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
