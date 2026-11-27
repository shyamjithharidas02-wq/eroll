import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../app/routes/app_route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../data/models/staff_member.dart';
import '../data/staff_repository.dart';
import '../widgets/staff_row.dart';
import 'staff_profile_page.dart';

class StaffsPage extends StatelessWidget {
  const StaffsPage({super.key});

  static const double _hPad = 20;

  /// Opens the profile. Root navigator so it covers the bottom nav bar.
  void _openMember(BuildContext context, StaffMember m) => Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute(builder: (_) => StaffProfilePage(memberId: m.id)));

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<StaffRepository>();
    final staff = repo.staff;
    final pastCrew = repo.pastCrew;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(_hPad, 26, _hPad, bottomInset + 110),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Staff',
                      style: context.textTheme.headlineLarge!.copyWith(
                        fontSize: 34,
                        letterSpacing: -0.5,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  _AddButton(
                    onTap: () => Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(AppRouteNames.createStaffScreen),
                  ),
                ],
              ),
              const Gap(12),
              Text(
                '${staff.length} active · tap a name to see days, advances '
                'and pay history',
                style: context.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  color: AppColors.inkMuted,
                ),
              ),
              const Gap(16),
              if (staff.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Text(
                    'No crew yet. Tap Add to bring someone on.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < staff.length; i++) ...[
                        if (i > 0)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.canvas,
                          ),
                        StaffRow(
                          member: staff[i],
                          onTap: () => _openMember(context, staff[i]),
                        ),
                      ],
                    ],
                  ),
                ),
              if (pastCrew.isNotEmpty) ...[
                const Gap(28),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
                  child: Text(
                    'PAST CREW',
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontSize: 13,
                      letterSpacing: 0.8,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      for (final (i, m) in pastCrew.indexed) ...[
                        if (i > 0)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.canvas,
                          ),
                        _PastCrewRow(
                          member: m,
                          onRestore: () {
                            repo.restore(m.id);
                            Utils.showSnackBar(
                              '${m.name} is back on the crew',
                              context,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

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
                'Add',
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

class _PastCrewRow extends StatelessWidget {
  final StaffMember member;
  final VoidCallback onRestore;

  const _PastCrewRow({required this.member, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 63,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.chip,
              shape: BoxShape.circle,
            ),
            child: Text(
              member.initial,
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 16,
                color: AppColors.inkMuted,
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontSize: 16,
                    color: AppColors.inkMuted,
                  ),
                ),
                Text(
                  '${member.role.label} · '
                  '${Utils.formatRupee(member.dailyWage)}/day',
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onRestore,
            style: TextButton.styleFrom(foregroundColor: AppColors.pine),
            child: Text(
              'Bring back',
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 14.5,
                color: AppColors.pine,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
