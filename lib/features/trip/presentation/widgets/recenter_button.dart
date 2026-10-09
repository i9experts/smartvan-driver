import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

/// "Re-center": shown over the trip map once the driver has moved it away
/// from the van.
class RecenterButton extends StatelessWidget {
  const RecenterButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        heroTag: null,
        onPressed: onPressed,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1B3B69),
        icon: const Icon(Icons.my_location, size: 20),
        label: Text(context.l10n.tripRecenter,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
      );
}
