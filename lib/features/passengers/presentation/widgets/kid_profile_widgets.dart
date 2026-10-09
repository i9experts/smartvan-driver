import 'package:flutter/material.dart';

class KidSectionTitle extends StatelessWidget {
  const KidSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A2E),
          fontFamily: 'Poppins',
        ),
      );
}

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );

/// White card with [children] separated by dividers.
class KidInfoCard extends StatelessWidget {
  const KidInfoCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Divider(height: 1, color: Color(0xFFEAECF0)),
          ],
        ],
      ),
    );
  }
}

/// A labelled value; with [onCall] and a real value it gets a green call
/// button and green icon.
class KidInfoRow extends StatelessWidget {
  const KidInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onCall,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    final callable = onCall != null;
    final accent = callable ? const Color(0xFF27AE60) : const Color(0xFF1B3B69);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A94A6),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          if (callable && value != '—')
            GestureDetector(
              onTap: onCall,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.call, color: Colors.white, size: 18),
              ),
            ),
        ],
      ),
    );
  }
}

class KidAddressCard extends StatelessWidget {
  const KidAddressCard({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1B3B69).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.home_outlined,
                color: Color(0xFF1B3B69), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              address,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A2E),
                fontFamily: 'Poppins',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
