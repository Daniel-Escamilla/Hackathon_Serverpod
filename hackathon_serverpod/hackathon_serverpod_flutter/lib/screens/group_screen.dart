import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../data/group_repository.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../ui/app_button.dart';
import '../ui/failure_messages.dart';
import '../ui/feedback.dart';
import '../ui/sounds.dart';

/// The group: its invite code, who is in it, and — for the admin — the two
/// things that protect it when a code leaks: expelling a member and replacing
/// the code (PRODUCT.md §7). Everything here comes from `GroupEndpoint`.
class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final group = ref.watch(myGroupProvider);
    final members = ref.watch(groupMembersProvider);
    final me = ref.watch(signedInUserIdProvider);

    final isAdmin =
        members.value?.any(
          (m) => m.authUserId == me && m.role == GroupMemberRole.admin,
        ) ??
        false;

    return Scaffold(
      appBar: AppBar(title: Text(group.value?.name ?? l10n.groupTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myGroupProvider);
            ref.invalidate(groupMembersProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              switch (group) {
                AsyncValue(:final value?) => _InviteCard(
                  code: value.inviteCode,
                  canRegenerate: isAdmin,
                ),
                AsyncError(:final error) => Text(failureMessage(error, l10n)),
                _ => const SizedBox(height: 120),
              },
              const SizedBox(height: 28),
              Text(
                l10n.groupMembers,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              switch (members) {
                AsyncValue(:final value?) => Column(
                  children: [
                    for (final member in value)
                      _MemberRow(
                        member: member,
                        isMe: member.authUserId == me,
                        canExpel:
                            isAdmin &&
                            member.authUserId != me &&
                            member.role != GroupMemberRole.admin,
                      ),
                  ],
                ),
                AsyncError(:final error) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(failureMessage(error, l10n)),
                ),
                _ => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _InviteCard extends ConsumerWidget {
  const _InviteCard({required this.code, required this.canRegenerate});

  final String code;
  final bool canRegenerate;

  Future<void> _regenerate(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final go = await confirmAction(
      context,
      title: l10n.groupInviteRegenerateTitle,
      body: l10n.groupInviteRegenerateBody,
      action: l10n.groupInviteRegenerate,
    );
    if (!go || !context.mounted) return;

    try {
      await ref.read(groupRepositoryProvider).regenerateInviteCode();
      ref.invalidate(myGroupProvider);
      if (context.mounted) {
        showMessage(
          context,
          l10n.groupInviteRegenerated,
          sound: AppSound.success,
        );
      }
    } catch (error) {
      if (context.mounted) {
        showMessage(context, failureMessage(error, l10n), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: appViolet,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.groupInviteLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              height: 1,
              letterSpacing: 6,
              fontWeight: FontWeight.w900,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppButton(
                label: l10n.groupInviteCopy,
                onBrand: true,
                compact: true,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                  if (context.mounted) {
                    showMessage(context, l10n.groupInviteCopied);
                  }
                },
              ),
              if (canRegenerate)
                AppButton(
                  label: l10n.groupInviteRegenerate,
                  kind: AppButtonKind.quiet,
                  onBrand: true,
                  compact: true,
                  onPressed: () => _regenerate(context, ref),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemberRow extends ConsumerWidget {
  const _MemberRow({
    required this.member,
    required this.isMe,
    required this.canExpel,
  });

  final GroupMember member;
  final bool isMe;
  final bool canExpel;

  Future<void> _expel(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final name = member.displayName;
    final go = await confirmAction(
      context,
      title: l10n.expelTitle(name),
      body: l10n.expelBody,
      action: l10n.expelAction,
      destructive: true,
    );
    if (!go || !context.mounted) return;

    try {
      await ref.read(groupRepositoryProvider).expel(member.id!);
      ref.invalidate(groupMembersProvider);
      if (context.mounted) showMessage(context, l10n.expelDone(name));
    } catch (error) {
      if (context.mounted) {
        showMessage(context, failureMessage(error, l10n), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(member.displayName, style: text.titleMedium),
                if (member.role == GroupMemberRole.admin)
                  _Badge(l10n.memberRoleAdmin, color: appLime),
                if (isMe) _Badge(l10n.memberYou, color: appSky),
              ],
            ),
          ),
          if (canExpel)
            AppButton(
              label: l10n.expelAction,
              kind: AppButtonKind.danger,
              compact: true,
              onPressed: () => _expel(context, ref),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, {required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: appInk,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
