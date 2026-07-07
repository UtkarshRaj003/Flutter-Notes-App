import 'package:flutter/material.dart';
import 'package:frontend/screens/notes/edit_note_screen.dart';
import 'package:provider/provider.dart';
import '../../../models/note_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notes_provider.dart';
import '../../../widgets/note_card.dart';

class NotesList extends StatefulWidget {
  final List<NoteModel> notes;
  final ScrollController controller;

  const NotesList({super.key, required this.notes, required this.controller});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  // Selection state ko track karne ke liye variables
  bool _isSelectionMode = false;
  final Set<String> _selectedNoteIds = {};

  // Selection toggle karne ka helper function
  void _toggleSelection(String noteId) {
    setState(() {
      if (_selectedNoteIds.contains(noteId)) {
        _selectedNoteIds.remove(noteId);
        if (_selectedNoteIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedNoteIds.add(noteId);
      }
    });
  }

  // Selection clear karne ke liye
  void _clearSelection() {
    setState(() {
      _selectedNoteIds.clear();
      _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token ?? '';
    final notesProvider = context.read<NotesProvider>();

    return WillPopScope(
      // Agar selection mode on hai aur user back press kare, toh pehle selection off ho
      onWillPop: () async {
        if (_isSelectionMode) {
          _clearSelection();
          return false;
        }
        return true;
      },
      child: Column(
        children: [
          // === DYNAMIC ACTION BAR (Jab selection on ho) ===
          if (_isSelectionMode)
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _clearSelection,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_selectedNoteIds.length} Selected',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const Spacer(),

                  // Rule 1: SINGLE SELECTION (Sirf 1 note select ho toh PIN aur ARCHIVE dikhao)
                  if (_selectedNoteIds.length == 1) ...[
                    IconButton(
                      icon: const Icon(Icons.push_pin_outlined),
                      tooltip: 'Pin/Unpin',
                      onPressed: () {
                        final targetId = _selectedNoteIds.first;
                        notesProvider.togglePinStatus(
                          token: token,
                          noteId: targetId,
                        );
                        _clearSelection();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.archive_outlined),
                      tooltip: 'Archive',
                      onPressed: () {
                        final targetId = _selectedNoteIds.first;
                        final currentNote = widget.notes.firstWhere(
                          (n) => n.id == targetId,
                        );
                        // Archive status toggle karke updateNote call kar diya
                        notesProvider.updateNote(
                          token: token,
                          noteId: targetId,
                          title: currentNote.title,
                          content: currentNote.content,
                          tags: currentNote.tags,
                          isPinned: currentNote.isPinned,
                          isArchived: !currentNote.isArchived,
                        );
                        _clearSelection();
                      },
                    ),
                  ],

                  // Rule 2: MULTIPLE/SINGLE SELECTION (Delete humesha dikhega)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () async {
                      // Loop chala kar saari selected notes delete kar dega
                      for (var id in _selectedNoteIds) {
                        await notesProvider.deleteNote(
                          token: token,
                          noteId: id,
                        );
                      }
                      _clearSelection();
                    },
                  ),
                ],
              ),
            ),

          // === MAIN NOTES LIST ===
          Expanded(
            child: ListView.builder(
              controller: widget.controller,
              padding: const EdgeInsets.only(top: 10, bottom: 100),
              itemCount: widget.notes.length,
              itemBuilder: (context, index) {
                final note = widget.notes[index];
                final isSelected = _selectedNoteIds.contains(note.id);

                return GestureDetector(
                  onTap: () {
                    if (_isSelectionMode) {
                      _toggleSelection(note.id);
                    } else {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditNoteScreen(note: note),
                        ),
                      );
                    }
                  },
                  // HOLD/LONG PRESS karne par selection mode trigger hoga
                  onLongPress: () {
                    if (!_isSelectionMode) {
                      setState(() {
                        _isSelectionMode = true;
                        _selectedNoteIds.add(note.id);
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // Selected note ka background halka blue/primary color ka ho jayega
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.15)
                          : Colors.transparent,
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: IgnorePointer(
                      // Jab selection mode on ho, toh Card ke andar ke buttons click disable ho jayein
                      ignoring: _isSelectionMode,
                      child: NoteCard(
                        note: note,
                        onPinToggle: () {
                          notesProvider.togglePinStatus(
                            token: token,
                            noteId: note.id,
                          );
                        },
                        onDelete: () {
                          notesProvider.deleteNote(
                            token: token,
                            noteId: note.id,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
