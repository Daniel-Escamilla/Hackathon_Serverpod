import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../ui/feedback.dart';
import '../../ui/sounds.dart';
import 'activity_text.dart';

/// Shows another member's action the moment it happens (#158): the same
/// sentence as the Activity list, as a message at the bottom with a pop.
/// It is the "A B le salta el aviso en vivo" moment of the video script
/// (PLAN.md §2).
void showLiveNotice(
  BuildContext context,
  GroupEvent event,
  List<GroupMember> members,
) {
  final l10n = AppLocalizations.of(context);
  final name =
      members
          .firstWhereOrNull((m) => m.id == event.actorMemberId)
          ?.displayName ??
      l10n.activitySomeone;
  showMessage(context, event.sentence(l10n, name), sound: AppSound.tap);
}
