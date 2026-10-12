import 'package:flutter/material.dart';

/// Full-screen van/school photo with a navy scrim at the top, shared by the
/// auth screens. Pair it with [AuthSheet] for forms that sit on the photo.
class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF0B1B3F)),
        Image.asset(
          'assets/images/login_bg.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x660B1B3F), Color(0x000B1B3F)],
              stops: [0, 0.2],
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Bottom-anchored form area: wraps its content, fades from the photo into
/// navy so text and fields stay readable, and scrolls when space runs out.
class AuthSheet extends StatelessWidget {
  const AuthSheet({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x000B1B3F), Color(0xE60B1B3F), Color(0xFF0B1B3F)],
            stops: [0, 0.22, 0.45],
          ),
        ),
        padding: const EdgeInsets.only(top: 48),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomInset),
          children: children,
        ),
      ),
    );
  }
}
