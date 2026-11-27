import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/attendance_models.dart';
import 'attendance_toggle.dart';

/// Site header ("MEPPADI · RAJEEV'S BOREWELL   Move") and its worker card.
class SiteAttendanceSection extends StatelessWidget {
  final AttendanceGroup group;
  final AttendanceStatus Function(Worker worker) statusOf;
  final void Function(Worker worker, AttendanceStatus status)? onMark;
  final VoidCallback onMove;

  const SiteAttendanceSection({
    super.key,
    required this.group,
    required this.statusOf,
    required this.onMark,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    final header = context.textTheme.headlineSmall!.copyWith(
      fontSize: 13,
      letterSpacing: 0.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  group.label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: header.copyWith(color: AppColors.inkMuted),
                ),
              ),
              TextButton(
                onPressed: onMove,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.pine,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Move', style: header.copyWith(letterSpacing: 0)),
              ),
            ],
          ),
        ),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              for (var i = 0; i < group.workers.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.canvas,
                  ),
                _WorkerRow(
                  worker: group.workers[i],
                  status: statusOf(group.workers[i]),
                  onChanged: onMark == null
                      ? null
                      : (s) => onMark!(group.workers[i], s),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkerRow extends StatelessWidget {
  final Worker worker;
  final AttendanceStatus status;
  final ValueChanged<AttendanceStatus>? onChanged;

  const _WorkerRow({
    required this.worker,
    required this.status,
    required this.onChanged,
  });

  static const Color _avatarBg = Color(0xFFDFEADC);

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;

    return SizedBox(
      height: 66,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _avatarBg,
              shape: BoxShape.circle,
            ),
            child: Text(
              worker.initial,
              style: bold.copyWith(fontSize: 14, color: AppColors.pine),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: bold.copyWith(
                    fontSize: 16,
                    height: 1.2,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  '₹${worker.dailyWage} / day',
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 13,
                    height: 1.3,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          AttendanceToggle(value: status, onChanged: onChanged),
        ],
      ),
    );
  }
}
