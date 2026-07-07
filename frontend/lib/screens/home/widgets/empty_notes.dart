import 'package:flutter/material.dart';

class EmptyNotes
    extends StatelessWidget {

  const EmptyNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(

            Icons.note_alt_outlined,

            size: 100,

            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 20),

          Text(

            'No Notes Yet',

            style: Theme.of(context)
                .textTheme
                .headlineSmall,
          ),

          const SizedBox(height: 8),

          Text(

            'Create your first note',

            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}