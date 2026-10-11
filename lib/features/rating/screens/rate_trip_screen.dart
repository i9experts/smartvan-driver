import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_service.dart';

/// Shown right after a driver ends a trip, for each parent on that trip who
/// hasn't been rated yet (the list comes from GET /rating/pendingRatings,
/// already filtered to this trip). Steps through one parent at a time —
/// rate & next, or skip — then returns to /home.
class RateTripScreen extends StatefulWidget {
  final List<Map<String, dynamic>> pendingRatees;

  const RateTripScreen({super.key, required this.pendingRatees});

  @override
  State<RateTripScreen> createState() => _RateTripScreenState();
}

class _RateTripScreenState extends State<RateTripScreen> {
  late final List<Map<String, dynamic>> _queue;
  int _index = 0;
  int _stars = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _queue = widget.pendingRatees;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _current => _queue[_index];

  void _advance() {
    if (_index >= _queue.length - 1) {
      if (mounted) context.go('/home');
      return;
    }
    setState(() {
      _index += 1;
      _stars = 0;
      _commentController.clear();
    });
  }

  Future<void> _submit() async {
    if (_stars == 0) return;
    setState(() => _isSubmitting = true);
    try {
      await ApiService.post('/rating/rateTrip', {
        'tripId': _current['tripId'],
        'rateeUserId': _current['parentId'],
        'stars': _stars,
        if (_commentController.text.trim().isNotEmpty)
          'comment': _commentController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Thanks for rating!'),
            backgroundColor: const Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
      _advance();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit rating: $e'),
            backgroundColor: const Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_queue.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/home');
      });
      return const SizedBox.shrink();
    }

    final parentName = _current['parentName'] ?? 'this parent';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3B69),
        foregroundColor: Colors.white,
        title: Text(
          'Rate parent (${_index + 1}/${_queue.length})',
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _advance,
            child: const Text('Skip', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
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
                backgroundColor: const Color(0xFF1B3B69).withOpacity(0.1),
                backgroundImage: (_current['parentImage'] as String?)?.isNotEmpty == true
                    ? NetworkImage(_current['parentImage'])
                    : null,
                child: (_current['parentImage'] as String?)?.isNotEmpty == true
                    ? null
                    : Text(
                        parentName.toString().isNotEmpty ? parentName[0].toUpperCase() : '?',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3B69)),
                      ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'How was your trip with $parentName?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final filled = i < _stars;
                  return IconButton(
                    iconSize: 40,
                    onPressed: () => setState(() => _stars = i + 1),
                    icon: Icon(
                      filled ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFB800),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                maxLines: 3,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Add a comment (optional)',
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
                onPressed: _isSubmitting || _stars == 0 ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3B69),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Submit Rating',
                        style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
