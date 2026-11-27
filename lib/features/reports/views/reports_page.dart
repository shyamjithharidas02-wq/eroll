import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/widgets/circle_back_top_bar.dart';
import '../../works/work_site/widgets/site_status_switcher.dart';
import '../../../app/routes/app_route_names.dart';
import '../models/month_report.dart';
import '../models/report_data.dart';
import '../widgets/period_report_card.dart';
import '../widgets/report_summary.dart';

enum ReportRange { month, year, allTime }

/// Profit reports: this month / this year / all time, with history below.
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  static const double _hPad = 20;
  static const _rangeLabels = ['Month', 'Year', 'All time'];

  final ReportsData _data = ReportsData.demo;
  ReportRange _range = ReportRange.month;

  String get _caption {
    final month = _data.currentMonth.start;
    return switch (_range) {
      ReportRange.month => '${DateFormat('MMMM').format(month)} so far',
      ReportRange.year => '${month.year} so far',
      ReportRange.allTime => 'Since ${_data.allTime.start.year}',
    };
  }

  PeriodReport get _summary => switch (_range) {
    ReportRange.month => _data.currentMonth,
    ReportRange.year => _data.currentYear,
    ReportRange.allTime => _data.allTime,
  };

  void _openMonth(PeriodReport month) => Navigator.pushNamed(
    context,
    AppRouteNames.monthReportScreen,
    arguments: MonthReport.demoFor(month, previous: _data.previousOf(month)),
  );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  _hPad,
                  media.padding.top + 12,
                  _hPad,
                  30,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.forest,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(44),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CircleBackTopBar(title: 'Reports', onDark: true),
                    const Gap(22),
                    SiteStatusSwitcher(
                      labels: _rangeLabels,
                      selectedIndex: _range.index,
                      backgroundColor: AppColors.forestSoft,
                      onChanged: (i) =>
                          setState(() => _range = ReportRange.values[i]),
                    ),
                    const Gap(30),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: ReportSummary(
                        key: ValueKey(_range),
                        caption: _caption,
                        report: _summary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ..._history(context, media.padding.bottom),
          ],
        ),
      ),
    );
  }

  /// "Past months" on the Month tab, yearly cards on Year / All time.
  List<Widget> _history(BuildContext context, double bottomInset) {
    final showMonths = _range == ReportRange.month;
    final items = switch (_range) {
      ReportRange.month => _data.pastMonths,
      ReportRange.year => _data.pastYears,
      ReportRange.allTime => _data.allYears,
    };
    final title = switch (_range) {
      ReportRange.month => 'Past months',
      ReportRange.year => 'Past years',
      ReportRange.allTime => 'By year',
    };
    final trailing = showMonths ? '${_data.currentMonth.start.year}' : '';

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(_hPad, 26, _hPad, 14),
        sliver: SliverToBoxAdapter(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontSize: 21,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                trailing,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontSize: 15,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
      if (items.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Nothing here yet',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium!.copyWith(
                color: AppColors.inkMuted,
              ),
            ),
          ),
        )
      else
        SliverPadding(
          padding: EdgeInsets.fromLTRB(_hPad, 0, _hPad, bottomInset + 24),
          sliver: SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Gap(10),
            itemBuilder: (context, i) {
              final r = items[i];
              return showMonths
                  ? PeriodReportCard(
                      report: r,
                      badgeTop: DateFormat('MMM').format(r.start),
                      badgeBottom: '${r.start.year}',
                      title: DateFormat('MMMM').format(r.start),
                      onTap: () => _openMonth(r),
                    )
                  : PeriodReportCard(
                      report: r,
                      badgeTop: '${r.start.year}',
                      badgeBottom: 'Year',
                      title: r.start.year == _data.currentMonth.start.year
                          ? '${r.start.year} so far'
                          : '${r.start.year}',
                    );
            },
          ),
        ),
    ];
  }
}
