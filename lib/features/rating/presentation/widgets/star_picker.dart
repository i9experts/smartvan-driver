import 'package:flutter/material.dart';

/// Five tappable stars; [stars] of them are filled.
class StarPicker extends StatelessWidget {
  const StarPicker({super.key, required this.stars, required this.onChanged});

  final int stars;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          final filled = i < stars;
          return IconButton(
            iconSize: 40,
            onPressed: () => onChanged(i + 1),
            icon: Icon(
              filled ? Icons.star : Icons.star_border,
              color: const Color(0xFFFFB800),
            ),
          );
        }),
      );
}
