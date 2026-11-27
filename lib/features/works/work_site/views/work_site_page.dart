import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:eroll/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../data/models/site_model.dart';
import '../widgets/delete_site_sheet.dart';
import '../widgets/site_card.dart';
import '../widgets/site_status_switcher.dart';

class WorkSitePage extends StatefulWidget {
  const WorkSitePage({super.key});

  @override
  State<WorkSitePage> createState() => _WorkSitePageState();
}

class _WorkSitePageState extends State<WorkSitePage> {
  static const double _hPad = 20;
  static const _statuses = SiteStatus.values;

  int _selected = SiteStatus.ongoing.index;

  final List<SiteModel> _sites = SiteModel.demo;

  List<SiteModel> _sitesFor(SiteStatus status) =>
      _sites.where((s) => s.status == status).toList();

  String _label(SiteStatus status) {
    final count = _sitesFor(status).length;
    final name = switch (status) {
      SiteStatus.todo => 'To do',
      SiteStatus.ongoing => 'Ongoing',
      SiteStatus.done => 'Done',
    };
    return '$name ($count)';
  }

  /// Opens the "New site" form and shows the created site in its tab.
  Future<void> _createSite() async {
    // Root navigator: the form covers the bottom nav bar.
    final site = await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed<SiteModel>(AppRouteNames.createWorkScreen);
    if (site == null || !mounted) return;
    setState(() {
      // TODO: replace with Firestore write; demo list is the in-memory store.
      _sites.insert(0, site);
      _selected = site.status.index;
    });
    Utils.showSnackBar('${site.title} created', context);
  }

  /// Shows the delete sheet. Returns true only when the card should slide
  /// away; "Mark as done" keeps the card and moves it to the Done tab.
  Future<bool> _confirmDelete(SiteModel site) async {
    final choice = await DeleteSiteSheet.show(context, site);
    if (!mounted) return false;
    if (choice == DeleteSiteChoice.markDone) {
      // TODO: persist the status change to Firestore.
      setState(() {
        final i = _sites.indexOf(site);
        if (i >= 0) _sites[i] = site.copyWith(status: SiteStatus.done);
      });
      Utils.showSnackBar('${site.title} moved to Done', context);
    }
    return choice == DeleteSiteChoice.delete;
  }

  void _delete(SiteModel site) {
    final index = _sites.indexOf(site);
    if (index < 0) return;
    // TODO: delete the site and its payments, costs and attendance in
    // Firestore (after the undo window closes).
    setState(() => _sites.removeAt(index));

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('${site.title} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.lime,
          onPressed: () {
            if (!mounted) return;
            setState(() => _sites.insert(index.clamp(0, _sites.length), site));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _sitesFor(_statuses[_selected]);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(_hPad, 26, _hPad, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sites',
                        style: context.textTheme.headlineLarge!.copyWith(
                          fontSize: 32,
                          letterSpacing: -0.5,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    _NewSiteButton(onTap: _createSite),
                  ],
                ),
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
                child: SiteStatusSwitcher(
                  labels: [for (final s in _statuses) _label(s)],
                  selectedIndex: _selected,
                  onChanged: (i) => setState(() => _selected = i),
                ),
              ),
              const Gap(16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: visible.isEmpty
                      ? Center(
                          key: ValueKey('empty-$_selected'),
                          child: Text(
                            'No sites here yet',
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: AppColors.inkMuted,
                            ),
                          ),
                        )
                      : ListView.separated(
                          key: ValueKey(_selected),
                          padding: EdgeInsets.fromLTRB(
                            _hPad,
                            0,
                            _hPad,
                            bottomInset + 16,
                          ),
                          itemCount: visible.length,
                          separatorBuilder: (_, _) => const Gap(12),
                          itemBuilder: (context, index) {
                            final site = visible[index];
                            return _SwipeToDelete(
                              key: ObjectKey(site),
                              confirm: () => _confirmDelete(site),
                              onDeleted: () => _delete(site),
                              child: SiteCard(
                                site: site,
                                // Root navigator: covers the bottom nav bar.
                                onTap: () =>
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pushNamed(
                                      AppRouteNames.siteDetailPage,
                                      arguments: site,
                                    ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewSiteButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NewSiteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lime,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 11, 18, 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, size: 22, color: AppColors.ink),
              const Gap(6),
              Text(
                'New site',
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 15,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Swipe right-to-left to reveal a red delete strip; the sheet decides
/// whether the card actually goes.
class _SwipeToDelete extends StatelessWidget {
  final Widget child;
  final Future<bool> Function() confirm;
  final VoidCallback onDeleted;

  const _SwipeToDelete({
    super.key,
    required this.child,
    required this.confirm,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.3},
      confirmDismiss: (_) => confirm(),
      onDismissed: (_) => onDeleted(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 28),
        decoration: BoxDecoration(
          color: AppColors.redTint,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.trash_copy, color: AppColors.red, size: 24),
            const Gap(4),
            Text(
              'Delete',
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 13,
                color: AppColors.red,
              ),
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}
