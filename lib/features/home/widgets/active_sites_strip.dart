import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/home_dashboard_data.dart';

/// Horizontally scrolling cards for the active work sites.
class ActiveSitesStrip extends StatelessWidget {
  final List<SiteSummary> sites;
  final EdgeInsets padding;
  final ValueChanged<SiteSummary>? onSiteTap;

  const ActiveSitesStrip({
    super.key,
    required this.sites,
    this.padding = EdgeInsets.zero,
    this.onSiteTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: sites.length,
        separatorBuilder: (_, _) => const Gap(12),
        itemBuilder: (context, index) {
          final site = sites[index];
          return _SiteCard(
            site: site,
            onTap: onSiteTap == null ? null : () => onSiteTap!(site),
          );
        },
      ),
    );
  }
}

class _SiteCard extends StatelessWidget {
  final SiteSummary site;
  final VoidCallback? onTap;

  const _SiteCard({required this.site, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: site.highlighted ? AppColors.pine : AppColors.forest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.location_copy,
                  size: 20,
                  color: site.highlighted ? AppColors.lime : AppColors.white,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      site.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontSize: 17,
                        color: AppColors.ink,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      '+${Utils.formatRupee(site.amount)} · '
                      '${site.workersToday} today',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontSize: 13,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
