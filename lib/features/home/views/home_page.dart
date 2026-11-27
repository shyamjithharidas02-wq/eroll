import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../entries/widgets/add_entry_sheet.dart';
import '../../works/work_site/data/models/site_model.dart';
import '../models/home_dashboard_data.dart';
import '../widgets/active_sites_strip.dart';
import '../widgets/crew_strip.dart';
import '../widgets/home_header.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_section_header.dart';
import '../widgets/more_sheet.dart';
import '../widgets/wage_summary_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onOpenTab});

  /// Lets the home screen jump to another bottom-nav tab (e.g. "See all").
  final ValueChanged<int>? onOpenTab;

  static const double _hPad = 22;

  /// How far the wage card hangs below the dark header.
  static const double _cardOverhang = 82;

  /// Opens the "Add entry" sheet on the tapped tab.
  Future<void> _addEntry(BuildContext context, EntryType type) async {
    final result = await AddEntrySheet.show(context, initialType: type);
    if (result != null && context.mounted) {
      // TODO: persist the entry to Firestore.
      Utils.showSnackBar(result.summary, context);
    }
  }

  /// Opens the "More" sheet, then routes to the chosen shortcut.
  Future<void> _openMore(BuildContext context) async {
    // TODO: compute from site transactions and wages.
    const monthProfit = 58000;
    final action = await MoreSheet.show(context, monthProfit: monthProfit);
    if (action == null || !context.mounted) return;

    // Root navigator so pushed pages cover the bottom nav bar.
    final nav = Navigator.of(context, rootNavigator: true);
    switch (action) {
      case MoreAction.profit:
      case MoreAction.reports:
        nav.pushNamed(AppRouteNames.reportsScreen);
      case MoreAction.newSite:
        final site = await nav.pushNamed<SiteModel>(
          AppRouteNames.createWorkScreen,
        );
        if (site == null || !context.mounted) return;
        // TODO: replace with Firestore write; demo list is the in-memory store.
        SiteModel.demo.insert(0, site);
        Utils.showSnackBar('${site.title} created', context);
        onOpenTab?.call(1);
      case MoreAction.addStaff:
        nav.pushNamed(AppRouteNames.createStaffScreen);
      case MoreAction.settings:
        nav.pushNamed(AppRouteNames.settingsScreen);
      case MoreAction.exportPdf:
      case MoreAction.backup:
        Utils.showSnackBar('Coming soon', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = HomeDashboardData.demo;
    final media = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SingleChildScrollView(
          // Clamp so pulling down never reveals light canvas above the header.
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(bottom: media.padding.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dark header with the wage card overlapping its bottom edge.
              Stack(
                children: [
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: _cardOverhang,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.forest,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(44),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      _hPad,
                      media.padding.top + 20,
                      _hPad,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HomeHeader(
                          adminName: data.adminName,
                          wagesDue: data.wages.due,
                          hasNotifications: true,
                          onNotificationTap: () => Utils.showSnackBar(
                            'No new notifications',
                            context,
                          ),
                        ),
                        const Gap(28),
                        WageSummaryCard(
                          summary: data.wages,
                          onSettleTap: () => onOpenTab?.call(3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(22),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
                child: HomeQuickActions(
                  onAdvance: () => _addEntry(context, EntryType.advance),
                  onExpense: () => _addEntry(context, EntryType.expense),
                  onClientPaid: () => _addEntry(context, EntryType.clientPaid),
                  onMore: () => _openMore(context),
                ),
              ),
              const Gap(30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
                child: HomeSectionHeader(
                  title: 'Today’s crew',
                  actionLabel: '${data.crewPresent} of ${data.crewTotal} ›',
                  onActionTap: () => onOpenTab?.call(2),
                ),
              ),
              const Gap(14),
              CrewStrip(
                crew: data.crew,
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
              ),
              const Gap(20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
                child: HomeSectionHeader(
                  title: 'Active sites',
                  actionLabel: 'See all',
                  onActionTap: () => onOpenTab?.call(1),
                ),
              ),
              const Gap(14),
              ActiveSitesStrip(
                sites: data.sites,
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
                onSiteTap: (_) => onOpenTab?.call(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
