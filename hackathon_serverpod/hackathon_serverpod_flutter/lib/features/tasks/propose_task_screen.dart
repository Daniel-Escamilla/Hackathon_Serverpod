import 'package:flutter/material.dart';

import 'typical_tasks.dart';
import '../../ui/coin_amount.dart';
import '../../ui/pressable.dart';
import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/feedback.dart';
import 'task_review_screen.dart';

class ProposeTaskScreen extends StatefulWidget {
  const ProposeTaskScreen({super.key});

  @override
  State<ProposeTaskScreen> createState() => _ProposeTaskScreenState();
}

class _ProposeTaskScreenState extends State<ProposeTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _reward = 10;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showMessage(context, l10n.taskTitleEmptyError, isError: true);
      return;
    }
    pushPage(
      context,
      TaskReviewScreen(
        title: title,
        description: _descriptionController.text.trim(),
        reward: _reward,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FormScaffold(
      title: l10n.newTaskTitle,
      fields: [
        FieldLabel(l10n.typicalTasksLabel),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final typical in typicalTasks(l10n))
              _TypicalTaskChip(
                task: typical,
                selected: _titleController.text == typical.title,
                onTap: () => setState(() {
                  _titleController.text = typical.title;
                  _reward = typical.reward;
                }),
              ),
          ],
        ),
        const SizedBox(height: 18),
        FieldLabel(l10n.titleFieldLabel),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: l10n.taskTitleHint),
        ),
        const SizedBox(height: 18),
        FieldLabel(l10n.descriptionLabel),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(hintText: l10n.taskDescriptionHint),
        ),
        const SizedBox(height: 18),
        FieldLabel(l10n.rewardLabel),
        StepperValue(
          value: _reward,
          onChanged: (v) => setState(() => _reward = v),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.rewardHintNote,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.palette.muted),
        ),
      ],
      button: l10n.reviewProposal,
      onSubmit: _submit,
    );
  }
}

/// A typical chore as a card-like chip: its emoji, its name and its price.
/// The one that filled the form is drawn in violet.
class _TypicalTaskChip extends StatelessWidget {
  const _TypicalTaskChip({
    required this.task,
    required this.selected,
    required this.onTap,
  });

  final TypicalTask task;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final ink = selected ? Colors.white : palette.ink;
    return Pressable(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.violet : palette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.violet : palette.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(task.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              task.title,
              style: TextStyle(
                color: ink,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
            CoinAmount(
              coins: task.reward,
              size: 16,
              style: TextStyle(
                color: ink,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
