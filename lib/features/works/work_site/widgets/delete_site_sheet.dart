import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';
import '../../../../core/utils/utils.dart';
import '../../site_detail/data/models/site_detail_model.dart';
import '../data/models/site_model.dart';

enum DeleteSiteChoice { delete, markDone }

/// Confirms deleting a site, showing what records go with it and offering
/// "Mark as done" as the safer alternative.
class DeleteSiteSheet extends StatelessWidget {
  final SiteModel site;
  final SiteDetail detail;

  const DeleteSiteSheet({super.key, required this.site, required this.detail});

  static Future<DeleteSiteChoice?> show(BuildContext context, SiteModel site) {
    // TODO: load real counts from Firestore.
    final detail = SiteDetail.demoFor(site);
    return showModalBottomSheet<DeleteSiteChoice>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      barrierColor: AppColors.forest.withValues(alpha: 0.88),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => DeleteSiteSheet(site: site, detail: detail),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payments = detail.transactions.where((t) => t.isIncome).toList();
    final costs = detail.transactions.where((t) => !t.isIncome).toList();
    final days = detail.crew.fold(0, (sum, c) => sum + c.days);
    final hasRecords = payments.isNotEmpty || costs.isNotEmpty || days > 0;
    final canMarkDone = site.status != SiteStatus.done;

    final body = context.textTheme.bodyMedium!.copyWith(
      fontSize: 15.5,
      height: 1.45,
      color: AppColors.inkMuted,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        10,
        22,
        MediaQuery.paddingOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.fieldBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const Gap(20),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.redTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.trash_copy,
                color: AppColors.red,
                size: 24,
              ),
            ),
          ),
          const Gap(20),
          Text(
            'Delete ${site.title}?',
            style: context.textTheme.headlineSmall!.copyWith(
              fontSize: 22,
              height: 1.25,
              color: AppColors.ink,
            ),
          ),
          const Gap(8),
          Text(
            hasRecords
                ? 'This site has money recorded against it. Deleting removes '
                      'all of it from your reports and profit:'
                : 'Nothing has been recorded on this site yet. '
                      'This can’t be undone.',
            style: body,
          ),
          if (hasRecords) ...[
            const Gap(18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  _RecordRow(
                    label: 'Client payments',
                    value: _countAndSum(payments),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.fieldBorder,
                  ),
                  _RecordRow(label: 'Site costs', value: _countAndSum(costs)),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.fieldBorder,
                  ),
                  _RecordRow(label: 'Attendance days', value: '$days'),
                ],
              ),
            ),
          ],
          const Gap(18),
          if (canMarkDone) ...[
            _PillButton(
              label: 'Mark as done instead',
              icon: Iconsax.archive_1_copy,
              color: AppColors.forest,
              textColor: AppColors.white,
              onTap: () => Navigator.pop(context, DeleteSiteChoice.markDone),
            ),
            const Gap(12),
          ],
          Row(
            children: [
              Expanded(
                child: _PillButton(
                  label: 'Cancel',
                  color: AppColors.canvas,
                  textColor: AppColors.ink,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _PillButton(
                  label: 'Delete site',
                  color: AppColors.white,
                  textColor: AppColors.red,
                  borderColor: AppColors.lossTint,
                  onTap: () => Navigator.pop(context, DeleteSiteChoice.delete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _countAndSum(List<SiteTransaction> items) {
    if (items.isEmpty) return '0';
    final total = items.fold(0, (sum, t) => sum + t.amount.abs());
    return '${items.length} · ${Utils.formatRupee(total)}';
  }
}

class _RecordRow extends StatelessWidget {
  final String label;
  final String value;

  const _RecordRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
                color: AppColors.inkMuted,
              ),
            ),
          ),
          Text(
            value,
            style: context.textTheme.headlineSmall!.copyWith(
              fontSize: 15.5,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.icon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(27),
      side: borderColor == null
          ? BorderSide.none
          : BorderSide(color: borderColor!, width: 1.4),
    );
    return Material(
      color: color,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: SizedBox(
          height: 54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 22),
                const Gap(12),
              ],
              Text(
                label,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
