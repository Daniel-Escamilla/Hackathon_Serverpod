import 'package:flutter/material.dart';

import 'typical_tasks.dart';
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
      subtitle: l10n.newTaskSubtitle,
      fields: [
        FieldLabel(l10n.typicalTasksLabel),
        _TypicalTaskGrid(
          tasks: typicalTasks(l10n),
          selectedTitle: _titleController.text,
          onPick: (typical) => setState(() {
            _titleController.text = typical.title;
            _reward = typical.reward;
          }),
        ),
        const SizedBox(height: 10),
        _OrDivider(l10n.typicalTasksOr),
        const SizedBox(height: 10),
        FieldLabel(l10n.titleFieldLabel),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: l10n.taskTitleHint),
        ),
        const SizedBox(height: 18),
        FieldLabel(l10n.taskDescriptionOptionalLabel),
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

/// A hairline with [label] in the middle, between the ideas and the form.
class _OrDivider extends StatelessWidget {
  const _OrDivider(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        Expanded(child: Divider(color: palette.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(color: palette.muted, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Divider(color: palette.border)),
      ],
    );
  }
}

/// The typical chores two to a row, so every card is the same width
/// whatever the screen.
class _TypicalTaskGrid extends StatelessWidget {
  const _TypicalTaskGrid({
    required this.tasks,
    required this.selectedTitle,
    required this.onPick,
  });

  final List<TypicalTask> tasks;
  final String selectedTitle;
  final ValueChanged<TypicalTask> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < tasks.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final task in tasks.skip(i).take(2)) ...[
                    if (task != tasks[i]) const SizedBox(width: 8),
                    Expanded(
                      child: _TypicalTaskChip(
                        task: task,
                        selected: selectedTitle == task.title,
                        onTap: () => onPick(task),
                      ),
                    ),
                  ],
                  if (i + 1 >= tasks.length) ...[
                    const SizedBox(width: 8),
                    const Expanded(child: SizedBox()),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A typical chore as a card: its emoji and its name. The one that filled
/// the form is drawn in violet.
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
    return Pressable(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.violet : palette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.violet : palette.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(task.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  color: selected ? Colors.white : palette.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
