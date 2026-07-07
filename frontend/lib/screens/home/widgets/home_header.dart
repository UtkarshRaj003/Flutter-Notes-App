import 'package:flutter/material.dart';
import 'package:frontend/screens/notes/archived_notes_screen.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    String formattedName = userName[0].toUpperCase() + userName.substring(1).toLowerCase();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Welcome Back 👋',

                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 1),

              Text(formattedName, style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: Colors.grey.shade500)),
            ],
          ),

          IconButton(
            icon: const Icon(Icons.archive_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArchivedNotesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
