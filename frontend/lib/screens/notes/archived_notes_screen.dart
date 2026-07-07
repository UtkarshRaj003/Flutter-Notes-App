import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notes_provider.dart';
import '../../widgets/note_card.dart';
import 'edit_note_screen.dart';

class ArchivedNotesScreen extends StatefulWidget {
  const ArchivedNotesScreen({super.key});

  @override
  State<ArchivedNotesScreen> createState() => _ArchivedNotesScreenState();
}

class _ArchivedNotesScreenState extends State<ArchivedNotesScreen> {
  // Selection States
  bool _isSelectionMode = false;
  final Set<String> _selectedNoteIds = {};

  @override
  void initState() {
    super.initState();
    // Screen load hote hi backend se archived notes fetch karein
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token!;
      context.read<NotesProvider>().fetchNotes(
        token: token,
        refresh: true,
        archivedOnly: true,
      );
    });
  }

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

  void _clearSelection() {
    setState(() {
      _selectedNoteIds.clear(); // Corrected with ()
      _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final token = context.read<AuthProvider>().token!;
    final notesProvider = context.watch<NotesProvider>();
    final archivedNotes = notesProvider.archivedNotes;

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          _clearSelection();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isSelectionMode
              ? Text('${_selectedNoteIds.length} Selected')
              : const Text('Archived Notes'),
          leading: _isSelectionMode
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSelection,
                )
              : null, // Normal back button dikhega jab selection off ho
          actions: [
            if (_isSelectionMode) ...[
              // SINGLE SELECTION: Sirf 1 select hone par Pin aur Unarchive dikhao
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
                  icon: const Icon(Icons.unarchive_outlined), // Unarchive Icon
                  tooltip: 'Unarchive (Move to Home)',
                  onPressed: () {
                    final targetId = _selectedNoteIds.first;
                    final currentNote = archivedNotes.firstWhere(
                      (n) => n.id == targetId,
                    );
                    // isArchived: false karke home screen par wapas bhej diya
                    notesProvider.updateNote(
                      token: token,
                      noteId: targetId,
                      title: currentNote.title,
                      content: currentNote.content,
                      tags: currentNote.tags,
                      isPinned: currentNote.isPinned,
                      isArchived: false, // Send back to active notes
                    );
                    _clearSelection();
                  },
                ),
              ],
              // MULTIPLE/SINGLE SELECTION: Delete humesha chalega
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Delete Permanently',
                onPressed: () async {
                  for (var id in _selectedNoteIds) {
                    await notesProvider.deleteNote(token: token, noteId: id);
                  }
                  _clearSelection();
                },
              ),
            ],
          ],
        ),
        body: notesProvider.isLoading && archivedNotes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : archivedNotes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.archive_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No archived notes found',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: archivedNotes.length,
                itemBuilder: (context, index) {
                  final note = archivedNotes[index];
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
                    onLongPress: () {
                      if (!_isSelectionMode) {
                        setState(() {
                          _isSelectionMode = true;
                          _selectedNoteIds.add(note.id);
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _isSelectionMode && isSelected
                            ? theme.colorScheme.primary.withOpacity(0.15)
                            : Colors.transparent,
                        border: _isSelectionMode && isSelected
                            ? Border.all(
                                color: theme.colorScheme.primary,
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: IgnorePointer(
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
    );
  }
}
