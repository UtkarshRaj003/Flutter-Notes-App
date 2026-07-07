import 'package:flutter/material.dart';
import 'package:frontend/providers/tag_provider.dart';
import 'package:frontend/screens/home/widgets/app_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/notes_provider.dart';
import '../../utils/debounce.dart';

import '../notes/create_note_screen.dart';

import 'widgets/home_header.dart';
import 'widgets/home_search_section.dart';
import 'widgets/tag_filter_section.dart';
import 'widgets/loading_notes.dart';
import 'widgets/empty_notes.dart';
import 'widgets/notes_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();
  final debouncer = Debouncer(milliseconds: 500);

  String selectedTag = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token!;
      fetchNotes();
      context.read<TagProvider>().fetchTags(token: token, type: 'all');
    });

    _scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchNotes({bool refresh = false}) async {
    final token = context.read<AuthProvider>().token!;

    await context.read<NotesProvider>().fetchNotes(
      token: token,
      refresh: refresh,
      search: searchQuery,
      tag: selectedTag,
    );
  }

  void scrollListener() {
    final notesProvider = context.read<NotesProvider>();

    if (notesProvider.isLoading || !notesProvider.hasMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      fetchNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.watch yahan bilkul sahi hai kyunki UI changes par build rebuild hona chahiye
    final authProvider = context.watch<AuthProvider>();
    final notesProvider = context.watch<NotesProvider>();
    final tagProvider = context.watch<TagProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(),
            HomeHeader(userName: authProvider.userName ?? 'User'),
            const SizedBox(height: 10),
            HomeSearchSection(
              controller: searchController,
              onChanged: (value) {
                debouncer.run(() async {
                  searchQuery = value;
                  await fetchNotes(refresh: true);
                });
              },
            ),
            const SizedBox(height: 5),
            TagFilterSection(
              selectedTag: selectedTag,
              apiTags: tagProvider.tags,
              onTap: (tag) async {
                setState(() {
                  selectedTag = tag;
                });
                await fetchNotes(refresh: true);
              },
            ),
            Expanded(
              child: notesProvider.isLoading && notesProvider.notes.isEmpty
                  ? const LoadingNotes()
                  : !notesProvider.isLoading && notesProvider.notes.isEmpty
                  ? const EmptyNotes()
                  : RefreshIndicator(
                      onRefresh: () async {
                        await fetchNotes(refresh: true);
                      },
                      child: NotesList(
                        notes: notesProvider.notes,
                        controller: _scrollController,
                        // onRefreshRequired: () => fetchNotes(refresh: true),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateNoteScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }
}
