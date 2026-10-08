import 'package:flutter/material.dart';

/// A pull-to-refresh scroll view whose big header scrolls away with the
/// content, and a slim [pinnedBar] that fades in over the top once it has —
/// so the area under the status bar is never left bare.
class PinnedHeaderScroll extends StatefulWidget {
  const PinnedHeaderScroll({
    super.key,
    required this.pinnedBar,
    required this.onRefresh,
    required this.children,
    this.showBarAfter = 120,
    this.refreshColor = const Color(0xFF1B2B6B),
  });

  /// Shown at the top, full width, when scrolled past [showBarAfter].
  final Widget pinnedBar;
  final Future<void> Function() onRefresh;
  final List<Widget> children;

  /// Scroll offset (logical pixels) from which the bar shows.
  final double showBarAfter;
  final Color refreshColor;

  @override
  State<PinnedHeaderScroll> createState() => _PinnedHeaderScrollState();
}

class _PinnedHeaderScrollState extends State<PinnedHeaderScroll> {
  final ScrollController _scroll = ScrollController();

  /// Whether the pinned bar is showing (ephemeral UI state).
  final ValueNotifier<bool> _barVisible = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _barVisible.dispose();
    super.dispose();
  }

  void _onScroll() {
    _barVisible.value = _scroll.offset > widget.showBarAfter;
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          RefreshIndicator(
            onRefresh: widget.onRefresh,
            color: widget.refreshColor,
            child: SingleChildScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: widget.children),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: _barVisible,
              builder: (context, visible, child) => IgnorePointer(
                ignoring: !visible,
                child: AnimatedOpacity(
                  key: const Key('pinned-header-bar'),
                  opacity: visible ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: child,
                ),
              ),
              child: widget.pinnedBar,
            ),
          ),
        ],
      );
}
