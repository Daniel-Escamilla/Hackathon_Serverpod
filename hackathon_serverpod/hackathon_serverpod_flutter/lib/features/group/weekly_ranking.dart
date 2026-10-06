import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_animation.dart';
import '../../ui/coin_amount.dart';
import '../../ui/member_avatar.dart';

/// This week's ranking in the home (PRODUCT.md §4.6): karma earned minus
/// fines, spending left out, starting again on Monday at 00:00 in Madrid.
/// The server orders it; the top three get their place in colour.
class WeeklyRanking extends StatelessWidget {
  const WeeklyRanking({
    required this.entries,
    required this.myMemberId,
    super.key,
  });

  final List<RankingEntry> entries;
  final int? myMemberId;

  static const _podium = [AppColors.lime, AppColors.sky, AppColors.coral];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nobodyYet = entries.every((e) => e.netCoins == 0);
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppLottie(AppAnimation.rank, size: 56),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.rankingTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      l10n.rankingResets,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (nobodyYet)
            Text(
              l10n.rankingEmpty,
              style: const TextStyle(color: AppColors.muted),
            )
          else
            for (final (index, entry) in entries.indexed)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: index < _podium.length
                          ? _podium[index]
                          : AppColors.cream,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w900,
                          fontFeatures: AppFonts.tabularFigures,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    MemberAvatar(
                      name: entry.displayName,
                      avatar: entry.avatarEmoji,
                      color: entry.avatarColor,
                      radius: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.memberId == myMemberId
                            ? '${entry.displayName} · ${l10n.memberYou}'
                            : entry.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CoinAmount(
                      coins: entry.netCoins,
                      size: 20,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
