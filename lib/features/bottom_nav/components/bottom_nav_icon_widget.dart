import 'package:eroll/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A single bottom-nav item. The active item expands into a lime pill
/// showing its label; inactive items show only the icon.
class BottomNavIconWidget extends StatelessWidget {
  const BottomNavIconWidget({
    super.key,
    required this.icons,
    required this.onTap,
    required this.label,
    required this.isActive,
  });

  final IconData icons;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: isActive ? 18 : 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.lime : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icons,
                size: 23,
                color: isActive ? AppColors.ink : AppColors.navIcon,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: isActive
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          label,
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: 'cabinBold',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
