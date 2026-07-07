import 'package:flutter/material.dart';

class TagFilterSection extends StatelessWidget {
  final String selectedTag;
  final List<String> apiTags; // API/Provider se aaye hue tags accept karne ke liye
  final Function(String) onTap;

  const TagFilterSection({
    super.key,
    required this.selectedTag,
    required this.apiTags, // Isko required bana diya
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Current theme ki properties nikal li taaki colors adaptive ho jayein
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Hardcoded list hatakar, 'All' ke sath backend wale tags ko merge (spread) kar diya
    final tags = ['All', ...apiTags]; 

    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = tags[index];
          
          final isSelected = selectedTag == (tag == 'All' ? '' : tag);

          return ChoiceChip(
            label: Text(
              tag,
              style: TextStyle(
                color: isSelected 
                    ? theme.colorScheme.onPrimaryContainer 
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            onSelected: (_) {
              onTap(tag == 'All' ? '' : tag);
            },
            shape: const StadiumBorder(),
            side: BorderSide.none, 
            selectedColor: theme.colorScheme.primaryContainer,
            backgroundColor: isDarkMode 
                ? Colors.grey.shade900 
                : Colors.grey.shade300,
            showCheckmark: false, 
          );
        },
      ),
    );
  }
}