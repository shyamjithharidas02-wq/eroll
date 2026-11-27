import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/month_report.dart';

/// One row of the breakdown card: icon, title, amount, subtitle and a bar
/// showing this row's share against the largest row.
class BreakdownRowData {
  final Widget leading;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final double share; // 0..1
  final Color barColor;

  const BreakdownRowData({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    required this.share,
    required this.barColor,
  });

  static List<BreakdownRowData> sites(List<SiteMonthResult> sites) {
    final maxAbs = _max(sites.map((s) => s.profit.abs()));
    // Icon tiles cycle through the palette; a loss is always pink.
    const palette = [
      (AppColors.pine, AppColors.lime),
      (AppColors.forest, AppColors.lime),
      (AppColors.sand, AppColors.ink),
    ];
    return [
      for (final (i, s) in sites.indexed)
        BreakdownRowData(
          leading: _IconTile(
            icon: Icons.hardware_outlined,
            bg: s.profit < 0 ? AppColors.lossTint : palette[i % 3].$1,
            fg: s.profit < 0 ? AppColors.ink : palette[i % 3].$2,
          ),
          title: s.name,
          subtitle:
              '${s.location} · '
              '${s.ongoing ? 'ongoing' : 'finished ${DateFormat('d MMM').format(s.finishedOn!)}'}',
          amount:
              '${s.profit < 0 ? '– ' : '+ '}${Utils.formatRupee(s.profit.abs())}',
          amountColor: s.profit < 0 ? AppColors.red : AppColors.profitGreen,
          share: maxAbs == 0 ? 0 : s.profit.abs() / maxAbs,
          barColor: s.profit < 0
              ? AppColors.lossBar
              : (s.ongoing ? AppColors.lime : AppColors.pine),
        ),
    ];
  }

  static List<BreakdownRowData> staff(List<StaffMonthResult> staff) {
    final sorted = [...staff]..sort((a, b) => b.total.compareTo(a.total));
    final maxTotal = _max(sorted.map((s) => s.total));
    return [
      for (final s in sorted)
        BreakdownRowData(
          leading: _Initial(name: s.name),
          title: s.name,
          subtitle:
              '${s.days} day${s.days == 1 ? '' : 's'} · '
              '${Utils.formatRupee(s.dailyWage)}/day'
              '${s.extra == 0 ? '' : ' · ${s.extra > 0 ? '+' : '–'}${Utils.formatRupee(s.extra.abs())} extra'}',
          amount: Utils.formatRupee(s.total),
          amountColor: AppColors.ink,
          share: maxTotal == 0 ? 0 : s.total / maxTotal,
          barColor: AppColors.pine,
        ),
    ];
  }

  static List<BreakdownRowData> costs(List<CostMonthResult> costs) {
    final sorted = [...costs]..sort((a, b) => b.amount.compareTo(a.amount));
    final maxAmount = _max(sorted.map((c) => c.amount));
    return [
      for (final c in sorted)
        BreakdownRowData(
          leading: _IconTile(
            icon: _costIcon(c.category),
            bg: AppColors.chip,
            fg: AppColors.ink,
          ),
          title: c.label,
          subtitle: '${c.entries} entr${c.entries == 1 ? 'y' : 'ies'}',
          amount: Utils.formatRupee(c.amount),
          amountColor: AppColors.ink,
          share: maxAmount == 0 ? 0 : c.amount / maxAmount,
          barColor: AppColors.sand,
        ),
    ];
  }

  static IconData _costIcon(CostCategory c) => switch (c) {
    CostCategory.diesel => Iconsax.gas_station_copy,
    CostCategory.materials => Iconsax.box_copy,
    CostCategory.transport => Iconsax.truck_copy,
    CostCategory.food => Iconsax.coffee_copy,
    CostCategory.equipment => Iconsax.setting_2_copy,
    CostCategory.other => Iconsax.receipt_item_copy,
  };

  static int _max(Iterable<int> values) =>
      values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
}

/// White card listing [rows] with thin dividers.
class MonthBreakdownList extends StatelessWidget {
  final List<BreakdownRowData> rows;
  final String emptyText;

  const MonthBreakdownList({
    super.key,
    required this.rows,
    this.emptyText = 'Nothing recorded this month',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: rows.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                emptyText,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium!.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            )
          : Column(
              children: [
                for (final (i, row) in rows.indexed) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.canvas,
                    ),
                  _BreakdownRow(row: row),
                ],
              ],
            ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final BreakdownRowData row;

  const _BreakdownRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          row.leading,
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        row.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontSize: 16,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      row.amount,
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontSize: 16,
                        color: row.amountColor,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Text(
                  row.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 13.5,
                    color: AppColors.inkMuted,
                  ),
                ),
                const Gap(8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: row.share.clamp(0.04, 1.0),
                    minHeight: 5,
                    color: row.barColor,
                    backgroundColor: AppColors.chip,
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

class _IconTile extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;

  const _IconTile({required this.icon, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: fg),
    );
  }
}

class _Initial extends StatelessWidget {
  final String name;

  const _Initial({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.pine,
        shape: BoxShape.circle,
      ),
      child: Text(
        name.isEmpty ? '' : name[0].toUpperCase(),
        style: context.textTheme.headlineSmall!.copyWith(
          fontSize: 16,
          color: AppColors.lime,
        ),
      ),
    );
  }
}
