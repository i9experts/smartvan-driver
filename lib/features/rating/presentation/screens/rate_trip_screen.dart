import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../l10n/error_text.dart';
import '../../../../l10n/l10n.dart';
import '../../application/rate_trip_controller.dart';
import '../../application/rate_trip_state.dart';
import '../widgets/star_picker.dart';

/// Shown right after a driver ends a trip, for each parent on that trip who
/// hasn't been rated yet. Steps through one parent at a time — rate and
/// next, or skip — then returns to Home.
class RateTripScreen extends ConsumerStatefulWidget {
  const RateTripScreen({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<RateTripScreen> createState() => _RateTripScreenState();
}

class _RateTripScreenState extends ConsumerState<RateTripScreen> {
  final TextEditingController _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  RateTripController get _controller =>
      ref.read(rateTripControllerProvider(widget.tripId).notifier);

  void _after(RateTripAdvanced step) {
    if (step.finished) {
      context.go(AppRoutes.home);
    } else {
      _comment.clear();
    }
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final result = await _controller.submit(_comment.text);
    if (!mounted) return;
    switch (result) {
      case RateTripAdvanced():
        AppSnack.success(context, l10n.ratingThanks);
        _after(result);
      case RateTripFailed(:final error):
        AppSnack.error(
            context, l10n.ratingSubmitFailed(errorText(l10n, error)));
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rateTripControllerProvider(widget.tripId));
    final data = state.valueOrNull;
    if (data == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F6FA),
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF1B3B69))),
      );
    }
    if (data.queue.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoutes.home);
      });
      return const SizedBox.shrink();
    }
    return _RateTripBody(
      state: data,
      comment: _comment,
      onStars: _controller.setStars,
      onSkip: () => _after(_controller.skip()),
      onSubmit: _submit,
    );
  }
}

class _RateTripBody extends StatelessWidget {
  const _RateTripBody({
    required this.state,
    required this.comment,
    required this.onStars,
    required this.onSkip,
    required this.onSubmit,
  });

  final RateTripState state;
  final TextEditingController comment;
  final ValueChanged<int> onStars;
  final VoidCallback onSkip;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ratee = state.current;
    final name = ratee.parentName ?? l10n.ratingThisParent;
    final image = ratee.parentImage;
    final submitting = state.submitting;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3B69),
        foregroundColor: Colors.white,
        title: Text(
          l10n.ratingTitle(state.index + 1, state.queue.length),
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: submitting ? null : onSkip,
            child: Text(l10n.ratingSkip,
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'Poppins')),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF1B3B69).withValues(alpha: 0.1),
                backgroundImage:
                    image?.isNotEmpty == true ? NetworkImage(image!) : null,
                child: image?.isNotEmpty == true
                    ? null
                    : Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B3B69)),
                      ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l10n.ratingQuestion(name),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 24),
              StarPicker(stars: state.stars, onChanged: onStars),
              const SizedBox(height: 16),
              TextField(
                controller: comment,
                maxLines: 3,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: l10n.ratingCommentHint,
                  hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: submitting || state.stars == 0 ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3B69),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        l10n.ratingSubmit,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
