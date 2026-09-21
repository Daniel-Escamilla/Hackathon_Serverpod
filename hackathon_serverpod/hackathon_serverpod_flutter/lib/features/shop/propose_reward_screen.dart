import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/feedback.dart';
import '../../ui/sounds.dart';
import 'shop_controller.dart';

class ProposeRewardScreen extends StatefulWidget {
  const ProposeRewardScreen({super.key});

  @override
  State<ProposeRewardScreen> createState() => _ProposeRewardScreenState();
}

class _ProposeRewardScreenState extends State<ProposeRewardScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _price = 40;
  bool _loading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showMessage(context, l10n.rewardTitleEmptyError, isError: true);
      return;
    }
    setState(() => _loading = true);
    final controller = context.read<ShopController>();
    try {
      await controller.proposeReward(
        title,
        _descriptionController.text.trim(),
        _price,
      );
      if (mounted) {
        showMessage(context, l10n.rewardSentToVote, sound: AppSound.success);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) showMessage(context, l10n.rewardSubmitError, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FormScaffold(
      title: l10n.newRewardTitle,
      fields: [
        FieldLabel(l10n.titleFieldLabel),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: l10n.rewardTitleHint),
        ),
        const SizedBox(height: 18),
        FieldLabel(l10n.descriptionLabel),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(hintText: l10n.rewardDescriptionHint),
        ),
        const SizedBox(height: 18),
        FieldLabel(l10n.priceLabel),
        StepperValue(
          value: _price,
          onChanged: (v) => setState(() => _price = v),
        ),
        const SizedBox(height: 18),
        InfoRow(
          icon: Icons.how_to_vote_rounded,
          text: l10n.rewardVotingNotice,
        ),
      ],
      button: l10n.submitToVote,
      loading: _loading,
      onSubmit: _submit,
    );
  }
}
