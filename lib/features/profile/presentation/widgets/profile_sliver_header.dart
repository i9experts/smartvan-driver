import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

/// Collapsing header of the profile screen: avatar, name and "Driver" badge.
class ProfileSliverHeader extends StatelessWidget {
  const ProfileSliverHeader({
    super.key,
    required this.name,
    required this.image,
    required this.onEdit,
  });

  final String name;
  final String? image;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF1B3B69),
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: onEdit,
        ),
      ],
      flexibleSpace: Builder(builder: (context) {
        // 0 = fully open, 1 = collapsed to the toolbar.
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final t = settings == null
            ? 0.0
            : (1 -
                    (settings.currentExtent - settings.minExtent) /
                        (settings.maxExtent - settings.minExtent))
                .clamp(0.0, 1.0);
        return Stack(
          fit: StackFit.expand,
          children: [
            FlexibleSpaceBar(
              background: Opacity(
                opacity: (1 - t * 1.6).clamp(0.0, 1.0),
                child: _expanded(context),
              ),
            ),
            // The toolbar keeps the driver's name once the big header is gone.
            Positioned(
              top: MediaQuery.paddingOf(context).top,
              left: 0,
              right: 56,
              height: kToolbarHeight,
              child: Opacity(
                key: const Key('profile-collapsed-title'),
                opacity: ((t - 0.6) / 0.4).clamp(0.0, 1.0),
                child: _CollapsedTitle(name: name, image: image),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _expanded(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B3B69), Color(0xFF2D4099)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFEC610), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ClipOval(
                child: image != null
                    ? Image.network(
                        image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _AvatarFallback(name: name),
                      )
                    : _AvatarFallback(name: name),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEC610).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                context.l10n.profileDriver,
                style: const TextStyle(
                  color: Color(0xFFFEC610),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small avatar and name shown in the toolbar when the header is collapsed.
class _CollapsedTitle extends StatelessWidget {
  const _CollapsedTitle({required this.name, required this.image});

  final String name;
  final String? image;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFEC610), width: 2),
              ),
              child: ClipOval(
                child: image != null
                    ? Image.network(image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _AvatarFallback(name: name))
                    : _AvatarFallback(name: name),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B3B69), Color(0xFF2D4099)],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'D',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
