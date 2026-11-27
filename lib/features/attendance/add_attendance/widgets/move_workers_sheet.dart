import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:eroll/features/works/work_site/data/models/site_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/attendance_models.dart';

/// Bottom sheet to move workers of a group to another site (or to no site).
class MoveWorkersSheet extends StatelessWidget {
  final AttendanceGroup group;
  final List<SiteModel> sites;
  final void Function(Worker worker, SiteModel? site) onMove;

  const MoveWorkersSheet({
    super.key,
    required this.group,
    required this.sites,
    required this.onMove,
  });

  static Future<void> show(
    BuildContext context, {
    required AttendanceGroup group,
    required List<SiteModel> sites,
    required void Function(Worker worker, SiteModel? site) onMove,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) =>
          MoveWorkersSheet(group: group, sites: sites, onMove: onMove),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final destinations = <SiteModel?>[
      ...sites.where((s) => s != group.site),
      if (group.site != null) null,
    ];

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Move workers',
              style: bold.copyWith(fontSize: 20, color: AppColors.ink),
            ),
            const Gap(2),
            Text(
              'From ${group.label}',
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                color: AppColors.inkMuted,
              ),
            ),
            const Gap(16),
            for (final worker in group.workers) ...[
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.name,
                      style: bold.copyWith(fontSize: 16, color: AppColors.ink),
                    ),
                    const Gap(10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final site in destinations)
                          ActionChip(
                            label: Text(site?.title ?? 'No site'),
                            labelStyle: bold.copyWith(
                              fontSize: 13,
                              color: AppColors.ink,
                            ),
                            backgroundColor: AppColors.canvas,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                            onPressed: () {
                              onMove(worker, site);
                              Navigator.pop(context);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
