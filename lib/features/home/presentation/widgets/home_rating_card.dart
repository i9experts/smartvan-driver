import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../../rating/data/models/rating_summary.dart';

/// The driver's lifetime rating and completed-trip count, under the day's
/// numbers in the blue header.
class HomeRatingCard extends StatelessWidget {
  const HomeRatingCard({super.key, required this.summary});

  final RatingSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rated = summary.ratingCount > 0;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Color(0xFFFEC610), size: 26),
          const SizedBox(width: 10),
          Text(
            rated ? summary.avgRating.toStringAsFixed(1) : '—',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rated
                  ? l10n.ratingYourRating(summary.ratingCount)
                  : l10n.ratingNoRatingsYet,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${summary.completedTripCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                l10n.ratingTripsCompleted,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
