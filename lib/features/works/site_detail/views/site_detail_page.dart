import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';
import '../../../../core/utils/utils.dart';
import '../../work_site/data/models/site_model.dart';
import '../data/models/site_detail_model.dart';
import '../widgets/crew_days_chips.dart';
import '../widgets/money_list_card.dart';
import '../widgets/profit_summary_card.dart';
import '../widgets/record_payment_sheet.dart';

/// Full-screen site detail & profit page. Pushed on the root navigator, so
/// the bottom nav bar is not shown.
class SiteDetailPage extends StatefulWidget {
  final SiteModel site;

  const SiteDetailPage({super.key, required this.site});

  @override
  State<SiteDetailPage> createState() => _SiteDetailPageState();
}

class _SiteDetailPageState extends State<SiteDetailPage> {
  static const double _hPad = 20;

  late SiteDetail _detail = SiteDetail.demoFor(widget.site);

  String get _subtitle => [
    widget.site.location,
    ?widget.site.clientName,
    ?widget.site.clientPhone,
    'since ${DateFormat('d MMM').format(widget.site.startDate)}',
  ].join(' · ');

  Future<void> _record() async {
    final tx = await RecordPaymentSheet.show(context);
    if (tx == null || !mounted) return;
    setState(() {
      _detail = _detail.copyWith(transactions: [..._detail.transactions, tx]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final sectionStyle = bold.copyWith(
      fontSize: 13,
      letterSpacing: 0.4,
      color: AppColors.inkMuted,
    );
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 0, 10),
      child: Text(title.toUpperCase(), style: sectionStyle),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(_hPad, 20, _hPad, bottomInset + 24),
            children: [
              Row(
                children: [
                  _BackButton(onTap: () => Navigator.maybePop(context)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Utils.showSnackBar(
                      'Editing sites is coming soon',
                      context,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.pine,
                      textStyle: bold.copyWith(fontSize: 15),
                    ),
                    child: const Text('Edit'),
                  ),
                ],
              ),
              const Gap(18),
              Text(
                widget.site.title,
                style: context.textTheme.headlineLarge!.copyWith(
                  fontSize: 30,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              const Gap(4),
              Text(
                _subtitle,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  color: AppColors.inkMuted,
                ),
              ),
              const Gap(20),
              ProfitSummaryCard(
                received: _detail.received,
                wages: _detail.wages,
                siteCosts: _detail.siteCosts,
                contractValue: widget.site.contractValue,
                onRecord: _record,
              ),
              if (_detail.crew.isNotEmpty) ...[
                section('Crew on this site'),
                CrewDaysChips(crew: _detail.crew),
              ],
              if (_detail.transactions.isNotEmpty) ...[
                section('Money in & out'),
                MoneyListCard(transactions: _detail.transactions),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: AppColors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.chevron_left_rounded,
              size: 26,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
