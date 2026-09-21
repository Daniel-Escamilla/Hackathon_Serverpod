import 'package:flutter/material.dart';

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
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
      button: l10n.reviewProposal,
      onSubmit: _submit,
    );
  }
}
