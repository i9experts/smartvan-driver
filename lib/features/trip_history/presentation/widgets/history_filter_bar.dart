import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../../trip/data/models/trip_type.dart';

/// All / Pick up / Drop off chips. [selected] null means All.
class HistoryFilterBar extends StatelessWidget {
  const HistoryFilterBar(
      {super.key, required this.selected, required this.onSelected});

  final TripType? selected;
  final ValueChanged<TripType?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = <(TripType?, String)>[
      (null, l10n.historyFilterAll),
      (TripType.pick, l10n.historyFilterPick),
      (TripType.drop, l10n.historyFilterDrop),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          for (final (type, label) in options)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: selected == type,
                onSelected: (_) => onSelected(type),
              ),
            ),
        ],
      ),
    );
  }
}
