import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../../create_staff/views/add_staff_page.dart';
import '../../pay/models/pay_models.dart';
import '../../pay/views/worker_pay_detail_page.dart';
import '../../works/work_site/widgets/site_status_switcher.dart';
import '../data/models/staff_member.dart';
import '../data/staff_repository.dart';
import '../models/staff_month.dart';
import '../widgets/remove_staff_sheet.dart';

/// Opens this week's pay detail for [m] and records whatever gets paid.
Future<void> openWeeklyPay(BuildContext context, StaffMember m) async {
  final repo = context.read<StaffRepository>();
  final today = DateUtils.dateOnly(DateTime.now());
  final weekStart = DateTime(
    today.year,
    today.month,
    today.day - (today.weekday - 1),
  );
  final entry = m.toPayEntry();
  final amount = await Navigator.of(context, rootNavigator: true).push<int>(
    MaterialPageRoute(
      builder: (_) => WorkerPayDetailPage(
        entry: entry,
        weekStart: weekStart,
        // Whatever is no longer due has already been paid this week.
        alreadyPaid: m.dueThisWeek > 0 ? entry.payable - m.dueThisWeek : 0,
      ),
    ),
  );
  if (amount != null && amount > 0) {
    repo.recordPayment(m.id, amount);
    if (context.mounted) {
      Utils.showSnackBar(
        'Paid ${Utils.formatRupee(amount)} to ${m.name}',
        context,
      );
    }
  }
}

/// A crew member's profile with a month-by-month pay breakdown.
class StaffProfilePage extends StatefulWidget {
  final String memberId;

  const StaffProfilePage({super.key, required this.memberId});

  @override
  State<StaffProfilePage> createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends State<StaffProfilePage> {
  static const double _hPad = 20;
  static const int _monthsShown = 4;

  /// How far the stats card hangs below the dark header.
  static const double _overhang = 124;

  static const Color _avatarBg = Color(0xFFAECBBB);
  static const Color _brown = Color(0xFF8A5A1C);

  int _monthIndex = 0;

  /// Kept so the page can still render while popping after a removal.
  StaffMember? _last;

  List<DateTime> get _months {
    final now = DateTime.now();
    return [
      for (var i = 0; i < _monthsShown; i++) DateTime(now.year, now.month - i),
    ];
  }

  Future<void> _call(StaffMember m) async {
    if (m.phone.isEmpty) {
      Utils.showSnackBar('No phone number saved', context);
      return;
    }
    final ok = await launchUrl(
      Uri(scheme: 'tel', path: m.phone.replaceAll(' ', '')),
    );
    if (!ok && mounted) {
      Utils.showSnackBar('Could not open the dialer', context);
    }
  }

  void _edit(StaffMember m) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => AddStaffPage(initial: m)));

  Future<void> _remove(StaffMember m) async {
    final choice = await RemoveStaffSheet.show(context, m);
    if (!mounted || choice == null) return;
    if (choice == RemoveStaffChoice.settleFirst) {
      await openWeeklyPay(context, m);
      return;
    }

    final repo = context.read<StaffRepository>();
    final messenger = ScaffoldMessenger.of(context);
    // TODO: mark the member inactive in Firestore.
    repo.remove(m.id);
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${m.name} removed from crew'),
          action: SnackBarAction(
            label: 'Undo',
            textColor: AppColors.lime,
            onPressed: () => repo.restore(m.id),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final member =
        context.watch<StaffRepository>().byId(widget.memberId) ?? _last;
    if (member == null) {
      return const Scaffold(backgroundColor: AppColors.canvas);
    }
    _last = member;

    final months = _months;
    final month = StaffMonth.build(member, months[_monthIndex]);
    final media = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(bottom: media.padding.bottom + 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: _overhang,
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
                      media.padding.top + 12,
                      _hPad,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TopRow(onEdit: () => _edit(member)),
                        const Gap(18),
                        _ProfileHeader(
                          member: member,
                          onCall: () => _call(member),
                        ),
                        const Gap(18),
                        SiteStatusSwitcher(
                          labels: [
                            for (final m in months) DateFormat('MMM').format(m),
                          ],
                          selectedIndex: _monthIndex,
                          backgroundColor: AppColors.forestSoft,
                          onChanged: (i) => setState(() => _monthIndex = i),
                        ),
                        const Gap(18),
                        _MonthStatsCard(month: month),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(28),
                    const _SectionLabel('Weeks'),
                    _WeeksCard(
                      weeks: month.weeks,
                      onDueTap: () => openWeeklyPay(context, member),
                    ),
                    if (month.advances.isNotEmpty) ...[
                      const Gap(28),
                      const _SectionLabel('Advances'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          children: [
                            for (final (i, a) in month.advances.indexed) ...[
                              if (i > 0)
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.canvas,
                                ),
                              SizedBox(
                                height: 54,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        DateFormat('EEE, d MMM').format(a.date),
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(
                                              fontSize: 16,
                                              color: AppColors.ink,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      '– ${Utils.formatRupee(a.amount)}',
                                      style: context.textTheme.headlineSmall!
                                          .copyWith(
                                            fontSize: 16,
                                            color: _brown,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const Gap(24),
                    _RemoveButton(onTap: () => _remove(member)),
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

class _TopRow extends StatelessWidget {
  final VoidCallback onEdit;

  const _TopRow({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: AppColors.forestSoft,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).maybePop(),
            child: const SizedBox(
              width: 46,
              height: 46,
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.white,
                size: 26,
              ),
            ),
          ),
        ),
        const Spacer(),
        Material(
          color: AppColors.forestSoft,
          borderRadius: BorderRadius.circular(23),
          child: InkWell(
            borderRadius: BorderRadius.circular(23),
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 18, 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Iconsax.edit_2, color: AppColors.white, size: 20),
                  const Gap(8),
                  Text(
                    'Edit',
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontSize: 15.5,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final StaffMember member;
  final VoidCallback onCall;

  const _ProfileHeader({required this.member, required this.onCall});

  @override
  Widget build(BuildContext context) {
    final muted = context.textTheme.bodyMedium!.copyWith(
      fontSize: 14.5,
      height: 1.35,
      color: AppColors.onDarkMuted,
    );
    final contact = [
      if (member.phone.isNotEmpty) member.phoneDisplay,
      if (member.homePlace.isNotEmpty) member.homePlace,
    ].join(' · ');

    return Row(
      children: [
        Container(
          width: 76,
          height: 76,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _StaffProfilePageState._avatarBg,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.pine, width: 3),
          ),
          child: Text(
            member.initial,
            style: context.textTheme.headlineSmall!.copyWith(
              fontSize: 28,
              color: AppColors.ink,
            ),
          ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 25,
                  color: AppColors.white,
                ),
              ),
              const Gap(2),
              Text(
                '${member.role.label} · '
                '${Utils.formatRupee(member.dailyWage)}/day · '
                'paid ${member.payCycle.label.toLowerCase()}',
                style: muted,
              ),
              if (contact.isNotEmpty) ...[
                const Gap(2),
                Text(contact, style: muted),
              ],
            ],
          ),
        ),
        const Gap(10),
        Material(
          color: AppColors.lime,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onCall,
            child: const SizedBox(
              width: 54,
              height: 54,
              child: Icon(Iconsax.call_copy, color: AppColors.ink, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthStatsCard extends StatelessWidget {
  final StaffMonth month;

  const _MonthStatsCard({required this.month});

  @override
  Widget build(BuildContext context) {
    final label = context.textTheme.bodyMedium!.copyWith(fontSize: 13.5);
    final value = context.textTheme.headlineSmall!.copyWith(
      fontSize: 24,
      letterSpacing: -0.3,
    );

    Widget stat(String title, String amount) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: label.copyWith(color: AppColors.onDarkMuted)),
          const Gap(2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(amount, style: value.copyWith(color: AppColors.white)),
          ),
        ],
      ),
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.pine,
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 18),
            child: Row(
              children: [
                stat('Days worked', PayEntry.formatDays(month.days)),
                const Gap(10),
                stat('Earned', Utils.formatRupee(month.earned)),
                const Gap(10),
                stat(
                  'Advances',
                  month.advanceTotal == 0
                      ? Utils.formatRupee(0)
                      : '– ${Utils.formatRupee(month.advanceTotal)}',
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.lime,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paid this month',
                        style: label.copyWith(color: AppColors.forestSoft),
                      ),
                      Text(
                        Utils.formatRupee(month.paid),
                        style: value.copyWith(
                          fontSize: 20,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Still due',
                      style: label.copyWith(color: AppColors.forestSoft),
                    ),
                    Text(
                      Utils.formatRupee(month.due),
                      style: value.copyWith(fontSize: 20, color: AppColors.ink),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.headlineSmall!.copyWith(
          fontSize: 13,
          letterSpacing: 0.8,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

class _WeeksCard extends StatelessWidget {
  final List<StaffWeek> weeks;
  final VoidCallback onDueTap;

  const _WeeksCard({required this.weeks, required this.onDueTap});

  static String _range(StaffWeek w) {
    final start = w.start, end = w.end;
    if (start.month == end.month) {
      return '${start.day} – ${DateFormat('d MMM').format(end)}';
    }
    return '${DateFormat('d MMM').format(start)} – '
        '${DateFormat('d MMM').format(end)}';
  }

  static String _detail(StaffWeek w) {
    return switch (w.state) {
      WeekPayState.upcoming => 'Not started',
      WeekPayState.none => 'No days marked',
      _ =>
        '${PayEntry.formatDays(w.days)} day${w.days == 1 ? '' : 's'} × '
            '${Utils.formatRupee(w.dailyWage)}'
            '${w.advance > 0 ? ' – adv ${Utils.formatRupee(w.advance)}' : ''}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final regular = context.textTheme.bodyMedium!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          for (final (i, w) in weeks.indexed) ...[
            if (i > 0)
              const Divider(height: 1, thickness: 1, color: AppColors.canvas),
            InkWell(
              onTap: w.state == WeekPayState.due ? onDueTap : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _range(w),
                            style: bold.copyWith(
                              fontSize: 16.5,
                              color: AppColors.ink,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            _detail(w),
                            style: regular.copyWith(
                              fontSize: 14,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          switch (w.state) {
                            WeekPayState.upcoming || WeekPayState.none => '—',
                            WeekPayState.daily => Utils.formatRupee(w.earned),
                            _ => Utils.formatRupee(w.net),
                          },
                          style: bold.copyWith(
                            fontSize: 16.5,
                            color: AppColors.ink,
                          ),
                        ),
                        const Gap(2),
                        _StatusText(week: w),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  final StaffWeek week;

  const _StatusText({required this.week});

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (week.state) {
      WeekPayState.paid => ('Paid', AppColors.profitGreen),
      WeekPayState.daily => ('Paid daily', AppColors.profitGreen),
      WeekPayState.due =>
        week.paid > 0
            ? (
                '${Utils.formatRupee(week.due)} due Saturday',
                _StaffProfilePageState._brown,
              )
            : ('Due Saturday', _StaffProfilePageState._brown),
      WeekPayState.upcoming => ('Upcoming', AppColors.inkMuted),
      WeekPayState.none => ('', AppColors.inkMuted),
    };
    if (text.isEmpty) return const SizedBox.shrink();
    return Text(
      text,
      style: context.textTheme.headlineSmall!.copyWith(
        fontSize: 14,
        color: color,
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RemoveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
      side: const BorderSide(color: AppColors.lossTint, width: 1.4),
    );
    return Material(
      color: Colors.transparent,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Center(
            child: Text(
              'Remove from crew',
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 16.5,
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
