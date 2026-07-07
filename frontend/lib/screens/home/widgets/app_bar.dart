import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/profile_screen.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            'My Notes',

            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          ),

          InkWell(onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }, child: Icon(Icons.account_circle_outlined, size: 30)),
        ],
      ),
    );
  }
}
