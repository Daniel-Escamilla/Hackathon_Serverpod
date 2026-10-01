import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../data/app_failure.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/feedback.dart';
import '../../ui/member_avatar.dart';
import '../../ui/pressable.dart';
import '../../ui/sounds.dart';
import '../settings/settings_screen.dart';
import 'group_controller.dart';
import 'group_settings_screen.dart';

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

    final myMemberId = controller.myMemberId;
    final me = controller.members.where((m) => m.id == myMemberId).firstOrNull;
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
                  style: TextStyle(color: context.palette.muted),
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
                  const SizedBox(height: 6),
                  AppButton(
                    label: l10n.groupSettings,
                    kind: AppButtonKind.quiet,
                    compact: true,
                    onPressed: () => pushPage(
                      context,
                      GroupSettingsScreen(group: group, controller: controller),
                    ),
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
              isYou: member.id == myMemberId,
              canManage: isAdmin && member.id != myMemberId,
              onMakeAdmin: () => _transferAdmin(context, member),
              onExpel: () => _expel(context, member),
            ),
          const SizedBox(height: 26),
          AppButton(
            label: l10n.mySettings,
            kind: AppButtonKind.secondary,
            onPressed: () => pushPage(context, const SettingsScreen()),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: l10n.signOut,
            kind: AppButtonKind.quiet,
            onPressed: () => _signOut(context),
          ),
        ],
      ),
    );
  }

  /// Back to the welcome screen, so another account can sign in.
  Future<void> _signOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: l10n.signOutTitle,
      body: l10n.signOutBody,
      action: l10n.signOut,
    );
    if (!confirmed || !context.mounted) return;
    await signOutToStart(context, auth: controller.auth);
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

  /// The admin hands the role over and stays as a plain member: from the
  /// reload on, the admin actions disappear from this screen.
  Future<void> _transferAdmin(BuildContext context, GroupMember member) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: l10n.transferAdminTitle(member.displayName),
      body: l10n.transferAdminBody(member.displayName),
      action: l10n.transferAdminConfirm,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await context.read<GroupController>().transferAdmin(member.id!);
      if (context.mounted) {
        showMessage(
          context,
          l10n.transferAdminDone(member.displayName),
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
    required this.canManage,
    required this.onMakeAdmin,
    required this.onExpel,
  });

  final GroupMember member;
  final bool isYou;

  /// The signed-in admin, looking at someone else's row.
  final bool canManage;
  final VoidCallback onMakeAdmin;
  final VoidCallback onExpel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        child: Row(
          children: [
            MemberAvatar(
              name: member.displayName,
              emoji: member.avatarEmoji,
              color: member.avatarColor,
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
            if (canManage) ...[
              const SizedBox(width: 6),
              _RowAction(
                tooltip: l10n.transferAdminAction,
                icon: Icons.admin_panel_settings_rounded,
                color: AppColors.violet,
                onTap: onMakeAdmin,
              ),
              _RowAction(
                tooltip: l10n.expelAction,
                icon: Icons.person_remove_rounded,
                color: AppColors.coral,
                onTap: onExpel,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// An admin action on a member's row. Silent: each one opens a confirmation,
/// and the outcome makes the sound.
class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Pressable(
        onTap: onTap,
        sound: null,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
