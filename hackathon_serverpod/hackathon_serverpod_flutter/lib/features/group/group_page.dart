import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/widgets.dart';
import '../../data/app_failure.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/feedback.dart';
import '../../ui/pressable.dart';
import '../../ui/sounds.dart';
import 'group_controller.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GroupController>();
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        PageHeader(title: l10n.navGroup),
        Expanded(child: _Body(controller: controller)),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});

  final GroupController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!controller.hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    final group = controller.group;
    if (controller.error != null || group == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.error is AppFailure
                    ? (controller.error as AppFailure).message(l10n)
                    : l10n.errorGeneric,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: l10n.retry,
                kind: AppButtonKind.secondary,
                onPressed: controller.load,
              ),
            ],
          ),
        ),
      );
    }

    final myUserId = client.auth.authInfoListenable.value?.authUserId;
    final me = controller.members
        .where((m) => m.authUserId == myUserId)
        .firstOrNull;
    final isAdmin = me?.role == GroupMemberRole.admin;

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
        children: [
          SoftCard(
            color: AppColors.lime,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏠', style: TextStyle(fontSize: 48)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        group.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    StatusPill(
                      label: _typeLabel(l10n, group.type),
                      color: Colors.white,
                    ),
                  ],
                ),
                const Divider(height: 28),
                Text(
                  l10n.groupCodeLabel,
                  style: const TextStyle(color: AppColors.muted),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        group.inviteCode,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyCode(context, group.inviteCode),
                      tooltip: l10n.copyCode,
                      icon: const Icon(Icons.copy_rounded),
                    ),
                  ],
                ),
                if (isAdmin) ...[
                  const SizedBox(height: 10),
                  AppButton(
                    label: l10n.groupInviteRegenerate,
                    kind: AppButtonKind.quiet,
                    compact: true,
                    onPressed: () => _regenerateCode(context),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text(
            l10n.membersTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          for (final member in controller.members)
            _MemberRow(
              member: member,
              isYou: member.authUserId == myUserId,
              canExpel: isAdmin && member.authUserId != myUserId,
              onExpel: () => _expel(context, member),
            ),
        ],
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, GroupType type) => switch (type) {
    GroupType.sharedFlat => l10n.profileSharedFlat,
    GroupType.couple => l10n.profileCouple,
    GroupType.family => l10n.profileFamily,
  };

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    final l10n = AppLocalizations.of(context);
    showMessage(context, l10n.codeCopied);
  }

  Future<void> _regenerateCode(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: l10n.groupInviteRegenerateTitle,
      body: l10n.groupInviteRegenerateBody,
      action: l10n.groupInviteRegenerate,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await context.read<GroupController>().regenerateInviteCode();
      if (context.mounted) {
        showMessage(
          context,
          l10n.groupInviteRegenerated,
          sound: AppSound.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, failureMessage(e, l10n), isError: true);
      }
    }
  }

  Future<void> _expel(BuildContext context, GroupMember member) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: l10n.expelTitle(member.displayName),
      body: l10n.expelBody,
      action: l10n.expelAction,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await context.read<GroupController>().expel(member.id!);
      if (context.mounted) {
        showMessage(context, l10n.expelDone(member.displayName));
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, failureMessage(e, l10n), isError: true);
      }
    }
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.isYou,
    required this.canExpel,
    required this.onExpel,
  });

  final GroupMember member;
  final bool isYou;
  final bool canExpel;
  final VoidCallback onExpel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.sky,
              child: Text(member.displayName.substring(0, 1).toUpperCase()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                member.displayName,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            if (member.role == GroupMemberRole.admin) ...[
              StatusPill(
                label: l10n.memberRoleAdmin,
                color: const Color(0xFFE2DCFF),
              ),
              const SizedBox(width: 6),
            ],
            if (isYou) StatusPill(label: l10n.memberYou, color: AppColors.lime),
            if (canExpel) ...[
              const SizedBox(width: 6),
              Pressable(
                onTap: onExpel,
                sound: null,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.person_remove_rounded,
                    color: AppColors.coral,
                    size: 20,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
