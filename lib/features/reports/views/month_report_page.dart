import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/circle_back_top_bar.dart';
import '../../works/work_site/widgets/site_status_switcher.dart';
import '../models/month_report.dart';
import '../widgets/month_breakdown_list.dart';
import '../widgets/month_profit_card.dart';

enum _Tab { sites, staff, costs }

/// One month in detail: profit card, then Sites / Staff / Costs breakdowns.
class MonthReportPage extends StatefulWidget {
  final MonthReport report;

  const MonthReportPage({super.key, required this.report});

  @override
  State<MonthReportPage> createState() => _MonthReportPageState();
}

class _MonthReportPageState extends State<MonthReportPage> {
  static const double _hPad = 20;
  static const _tabLabels = ['Sites', 'Staff', 'Costs'];

  _Tab _tab = _Tab.sites;

  MonthReport get _r => widget.report;

  List<BreakdownRowData> get _rows => switch (_tab) {
    _Tab.sites => BreakdownRowData.sites(_r.sites),
    _Tab.staff => BreakdownRowData.staff(_r.staff),
    _Tab.costs => BreakdownRowData.costs(_r.costs),
  };

  (String, int) get _footer => switch (_tab) {
    _Tab.sites => (
      '${_r.summary.profit < 0 ? 'Loss' : 'Profit'} from '
          '${_r.sites.length} site${_r.sites.length == 1 ? '' : 's'}',
      _r.sites.fold(0, (a, s) => a + s.profit),
    ),
    _Tab.staff => (
      'Wages for ${_r.staff.length} crew',
      _r.staff.fold(0, (a, s) => a + s.total),
    ),
    _Tab.costs => ('Total costs', _r.costs.fold(0, (a, c) => a + c.amount)),
  };

  // TODO: generate the month PDF (e.g. with the `pdf` package).
  void _downloadPdf() => Utils.showSnackBar('PDF export coming soon', context);

  // TODO: share the PDF / a text summary (e.g. with `share_plus`).
  void _share() => Utils.showSnackBar('Sharing coming soon', context);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final (footerLabel, footerAmount) = _footer;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(
                _hPad,
                media.padding.top + 12,
                _hPad,
                media.padding.bottom + 110,
              ),
              children: [
                CircleBackTopBar(
                  title: DateFormat('MMMM yyyy').format(_r.summary.start),
                ),
                const Gap(18),
                MonthProfitCard(report: _r),
                const Gap(18),
                SiteStatusSwitcher(
                  labels: _tabLabels,
                  selectedIndex: _tab.index,
                  onChanged: (i) => setState(() => _tab = _Tab.values[i]),
                ),
                const Gap(18),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: MonthBreakdownList(key: ValueKey(_tab), rows: _rows),
                ),
                const Gap(18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          footerLabel,
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontSize: 15.5,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ),
                      Text(
                        '${footerAmount < 0 ? '– ' : ''}'
                        '${Utils.formatRupee(footerAmount.abs())}',
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontSize: 16,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: _hPad,
              right: _hPad,
              bottom: media.padding.bottom + 16,
              child: Row(
                children: [
                  Expanded(child: _DownloadButton(onTap: _downloadPdf)),
                  const Gap(12),
                  Material(
                    color: AppColors.forest,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _share,
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Iconsax.share_copy,
                          color: AppColors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DownloadButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.lime.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.ink,
                  size: 22,
                ),
                const Gap(10),
                Text(
                  'Download PDF',
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontSize: 17,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
