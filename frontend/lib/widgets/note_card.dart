import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onPinToggle; // Pin/Unpin trigger karne ke liye
  final VoidCallback onDelete; // Delete trigger karne ke liye

  const NoteCard({
    super.key,
    required this.note,
    required this.onPinToggle,
    required this.onDelete,
  });

  // Helper function jo tag ke name ke hisab se colors return karega
  Map<String, Color> _getTagColors(String tagName) {
    switch (tagName.toLowerCase()) {
      case 'work':
        return {'bg': Colors.blue.shade50, 'text': Colors.blue.shade700};
      case 'personal':
        return {'bg': Colors.purple.shade50, 'text': Colors.purple.shade700};
      case 'important':
        return {'bg': Colors.red.shade50, 'text': Colors.red.shade700};
      case 'ideas':
        return {'bg': Colors.green.shade50, 'text': Colors.green.shade700};
      case 'study':
        return {'bg': Colors.amber.shade50, 'text': Colors.amber.shade900};
      default:
        // Agar koi unknown tag ho toh clean grey look
        return {'bg': const Color.fromARGB(255, 216, 255, 246), 'text': Colors.grey.shade700};
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Pin/Unpin Button
                IconButton(
                  onPressed: onPinToggle, // Directly toggles pin from parent
                  icon: Transform.rotate(
                    angle: 0.8,
                    child: Icon(
                      note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: note.isPinned ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text('Delete Note'),
                          content: const Text('Are you sure?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Dialog close
                                onDelete(); // Parent delete logic call
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),

            if (note.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: note.tags.map((tag) {
                  final colors = _getTagColors(tag);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colors['bg'], // Light pastel background
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Soft rounded corners jaisa screenshot me hai
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: colors['text'], // Dark matching text color
                        fontSize: 12,
                        fontWeight: FontWeight.w600, // Thoda bold look ke liye
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
