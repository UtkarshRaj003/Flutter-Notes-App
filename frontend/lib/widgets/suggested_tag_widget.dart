import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notes_provider.dart';

class SuggestedTagsWidget extends StatefulWidget {
  final List<String> currentTags;
  final Function(String) onTagSelected;

  const SuggestedTagsWidget({
    super.key,
    required this.currentTags,
    required this.onTagSelected,
  });

  @override
  State<SuggestedTagsWidget> createState() => _SuggestedTagsWidgetState();
}

class _SuggestedTagsWidgetState extends State<SuggestedTagsWidget> {
  @override
  void initState() {
    super.initState();
    // Screen open hote hi backend se suggested tags trigger honge
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token!;
      context.read<NotesProvider>().loadSuggestedTags(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NotesProvider>();
    final suggestions = notesProvider.suggestedTags;

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'Suggested Tags:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final tag = suggestions[index];
              final isAlreadyAdded = widget.currentTags.contains(tag);

              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text('#$tag'),
                  selected: isAlreadyAdded,
                  onSelected: isAlreadyAdded
                      ? null // Agar pehle se added hai toh click disable
                      : (_) => widget.onTagSelected(tag),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}