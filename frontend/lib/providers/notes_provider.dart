import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class NotesProvider extends ChangeNotifier {
  final NoteService _noteService = NoteService();

  // Active aur Archived notes ke liye alag-alag lists maintain karenge
  List<NoteModel> _notes = [];
  List<NoteModel> _archivedNotes = [];
  List<String> _suggestedTags = [];

  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  // Getters
  List<NoteModel> get notes => _notes;
  List<NoteModel> get archivedNotes =>
      _archivedNotes; // Dedicated getter for archive screen
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  List<String> get suggestedTags => _suggestedTags;

  // FETCH NOTES
  Future<void> fetchNotes({
    required String token,
    bool refresh = false,
    String search = '',
    String tag = '',
    bool pinnedOnly = false,
    bool archivedOnly = false,
  }) async {
    try {
      if (refresh) {
        if (archivedOnly) {
          _archivedNotes = [];
        } else {
          _notes = [];
        }
        _currentPage = 1;
        _hasMore = true;
      }

      if (!_hasMore) return;

      _isLoading = true;
      notifyListeners();

      final response = await _noteService.fetchNotes(
        token: token,
        page: _currentPage,
        search: search,
        tag: tag,
        pinnedOnly: pinnedOnly,
        archivedOnly:
            archivedOnly, // Note: Make sure service maps this to 'isArchived'
      );

      final List fetchedNotes = response['notes'];
      final loadedNotes = fetchedNotes.map((note) {
        return NoteModel.fromJson(note);
      }).toList();

      if (loadedNotes.isEmpty) {
        _hasMore = false;
      } else {
        if (archivedOnly) {
          _archivedNotes.addAll(loadedNotes);
        } else {
          _notes.addAll(loadedNotes);
        }
        _currentPage++;
      }
    } catch (e) {
      debugPrint("Fetch Error: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE NOTE
  Future<void> createNote({
    required String token,
    required String title,
    required String content,
    required List<String> tags,
    required bool isPinned,
    required bool isArchived,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _noteService.createNote(
        token: token,
        title: title,
        content: content,
        tags: tags,
        isPinned: isPinned,
        isArchived: isArchived,
      );

      final newNote = NoteModel.fromJson(response);

      // Agar direct archived note banayi toh archive me daalein, nahi toh active me
      if (newNote.isArchived) {
        _archivedNotes.insert(0, newNote);
      } else {
        _notes.insert(0, newNote);
        _sortLocalNotes(_notes); // Nayi note par automatic sorting apply karein
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE NOTE
  Future<void> updateNote({
    required String token,
    required String noteId,
    required String title,
    required String content,
    required List<String> tags,
    required bool isPinned,
    required bool isArchived,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _noteService.updateNote(
        token: token,
        noteId: noteId,
        title: title,
        content: content,
        tags: tags,
        isPinned: isPinned,
        isArchived: isArchived,
      );

      final updatedNote = NoteModel.fromJson(response);

      // Dono lists se purani note hata/update karenge taaki data sync rahe
      _notes.removeWhere((note) => note.id == noteId);
      _archivedNotes.removeWhere((note) => note.id == noteId);

      // Naye status ke hisab se sahi list me data insert karenge
      if (updatedNote.isArchived) {
        _archivedNotes.insert(0, updatedNote);
      } else {
        _notes.insert(0, updatedNote);
        _sortLocalNotes(_notes);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE NOTE
  Future<void> deleteNote({
    required String token,
    required String noteId,
  }) async {
    try {
      await _noteService.deleteNote(token: token, noteId: noteId);

      // Dono lists se remove kar do safe rehne ke liye
      _notes.removeWhere((note) => note.id == noteId);
      _archivedNotes.removeWhere((note) => note.id == noteId);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // TOGGLE PIN STATUS (Optimistic UI Update)
  Future<void> togglePinStatus({
    required String token,
    required String noteId,
  }) async {
    // Check karein ki note kis list me maujood hai
    int activeIndex = _notes.indexWhere((note) => note.id == noteId);
    int archiveIndex = _archivedNotes.indexWhere((note) => note.id == noteId);

    if (activeIndex == -1 && archiveIndex == -1) return;

    final bool isFromActive = activeIndex != -1;
    final currentNote = isFromActive
        ? _notes[activeIndex]
        : _archivedNotes[archiveIndex];
    final newPinStatus = !currentNote.isPinned;

    // 1. Local State Instant Update
    if (isFromActive) {
      _notes[activeIndex] = currentNote.copyWith(isPinned: newPinStatus);
      _sortLocalNotes(_notes);
    } else {
      _archivedNotes[archiveIndex] = currentNote.copyWith(
        isPinned: newPinStatus,
      );
      _sortLocalNotes(_archivedNotes);
    }
    notifyListeners();

    try {
      // 2. Background Network Call
      await _noteService.updateNote(
        token: token,
        noteId: noteId,
        title: currentNote.title,
        content: currentNote.content,
        tags: currentNote.tags,
        isPinned: newPinStatus,
        isArchived: currentNote.isArchived,
      );
    } catch (e) {
      debugPrint("Backend failed to update pin status: $e");

      // Rollback Logic agar network fail ho jaye
      if (isFromActive) {
        int fbIndex = _notes.indexWhere((note) => note.id == noteId);
        if (fbIndex != -1) {
          _notes[fbIndex] = currentNote;
          _sortLocalNotes(_notes);
        }
      } else {
        int fbIndex = _archivedNotes.indexWhere((note) => note.id == noteId);
        if (fbIndex != -1) {
          _archivedNotes[fbIndex] = currentNote;
          _sortLocalNotes(_archivedNotes);
        }
      }
      notifyListeners();
    }
  }

  // Helper method jo bar-bar code likhne se bachaega (DRY Principle)
  void _sortLocalNotes(List<NoteModel> list) {
    list.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt); // Date latest top par
    });
  }

  Future<void> loadSuggestedTags(String token) async {
    try {
      // NoteService ke naye method ko call kiya
      final tags = await _noteService.fetchSuggestedTags(token: token);
      _suggestedTags = tags;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching suggested tags: $e");
    }
  }
}
