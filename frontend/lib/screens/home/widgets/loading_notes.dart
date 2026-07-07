import 'package:flutter/material.dart';

class LoadingNotes
    extends StatelessWidget {

  const LoadingNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return const Center(
      child:
          CircularProgressIndicator(),
    );
  }
}