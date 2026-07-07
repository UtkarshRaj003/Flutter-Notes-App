import 'package:flutter/material.dart';

class HomeSearchSection
    extends StatelessWidget {

  final TextEditingController
      controller;

  final Function(String)
      onChanged;

  const HomeSearchSection({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: TextField(

        controller: controller,

        onChanged: onChanged,

        decoration: InputDecoration(

          hintText: 'Search notes...',

          prefixIcon:
              const Icon(Icons.search),

          suffixIcon: controller
                  .text
                  .isNotEmpty
              ? IconButton(

                  onPressed: () {

                    controller.clear();

                    onChanged('');
                  },

                  icon:
                      const Icon(
                    Icons.clear,
                  ),
                )
              : null,

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
      ),
    );
  }
}