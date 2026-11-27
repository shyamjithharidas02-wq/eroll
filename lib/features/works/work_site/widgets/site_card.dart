import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';
import '../../../../core/utils/utils.dart';
import '../data/models/site_model.dart';

class SiteCard extends StatelessWidget {
  final SiteModel site;
  final VoidCallback? onTap;

  const SiteCard({super.key, required this.site, this.onTap});

  static const Color _chipBg = Color(0xFFE3EED9);
  static const Color _chipText = Color(0xFF2E7A4F);
  static const Color _track = Color(0xFFE1EBDC);

  String get _dateLabel {
    final date = DateFormat('d MMM').format(site.startDate);
    return switch (site.status) {
      SiteStatus.todo => 'starts $date',
      SiteStatus.ongoing => 'since $date',
      SiteStatus.done => 'started $date',
    };
  }

  String get _trailingLabel {
    if (site.status == SiteStatus.done) return 'Completed';
    if (site.status == SiteStatus.todo) return 'Not started';
    if (site.workersToday == 0) return 'Paused today';
    final noun = site.workersToday == 1 ? 'worker' : 'workers';
    return '${site.workersToday} $noun today';
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final regular = context.textTheme.bodyMedium!;
    final meta = regular.copyWith(fontSize: 14, color: AppColors.inkMuted);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(17, 17, 17, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: bold.copyWith(
                            fontSize: 17,
                            color: AppColors.ink,
                          ),
                        ),
                        const Gap(3),
                        Text(
                          '${site.location} · $_dateLabel',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: meta,
                        ),
                      ],
                    ),
                  ),
                  if (site.recentAmount > 0) ...[
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _chipBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '+ ${Utils.formatRupee(site.recentAmount)}',
                        style: bold.copyWith(fontSize: 14, color: _chipText),
                      ),
                    ),
                  ],
                ],
              ),
              const Gap(20),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: site.progress,
                  minHeight: 6,
                  backgroundColor: _track,
                  valueColor: const AlwaysStoppedAnimation(AppColors.pine),
                ),
              ),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${Utils.formatRupee(site.received)} of '
                      '${Utils.formatRupee(site.contractValue)} received',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: regular.copyWith(
                        fontSize: 13,
                        color: AppColors.ink.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(_trailingLabel, style: meta.copyWith(fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
