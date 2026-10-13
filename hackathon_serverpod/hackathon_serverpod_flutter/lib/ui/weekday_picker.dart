import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../l10n/generated/app_localizations.dart';
import 'pressable.dart';

/// A Monday of reference: each weekday's name is read off the week it starts.
final _monday = DateTime(2026, 10, 12);

/// The name of [weekday] (1 = Monday … 7 = Sunday) in the app's language.
String weekdayName(BuildContext context, int weekday) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final day = _monday.add(Duration(days: weekday - 1));
  return DateFormat.EEEE(locale).format(day);
}

/// "martes, jueves": the days a mission comes back on, in order.
String weekdayList(BuildContext context, List<int> weekdays) =>
    (weekdays.toList()..sort()).map((d) => weekdayName(context, d)).join(', ');

/// Seven round toggles, Monday first, for the days a task repeats on.
class WeekdayPicker extends StatelessWidget {
  const WeekdayPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    // From the ARB, not from intl: Spanish says X for miércoles, so martes
    // and miércoles do not both read M.
    final initials = AppLocalizations.of(context).weekdayInitials.split(',');
    return Row(
      children: [
        for (var day = 1; day <= 7; day++) ...[
          if (day > 1) const SizedBox(width: 6),
          Expanded(
            child: Tooltip(
              message: weekdayName(context, day),
              child: Semantics(
                button: true,
                selected: selected.contains(day),
                label: weekdayName(context, day),
                child: Pressable(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onChanged(
                    selected.contains(day)
                        ? ({...selected}..remove(day))
                        : {...selected, day},
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected.contains(day)
                          ? AppColors.violet
                          : palette.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected.contains(day)
                            ? AppColors.violet
                            : palette.border,
                        width: 1.5,
                      ),
                    ),
                    child: ExcludeSemantics(
                      child: Text(
                        initials[day - 1],
                        style: TextStyle(
                          color: selected.contains(day)
                              ? Colors.white
                              : palette.ink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
