import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/app_sizes.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/upcoming_event/view/upcoming_event_banner.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/resource_path.dart';
import '../widgets/ongoing_works_card.dart';
import '../widgets/quick_menu.dart';
import '../widgets/reports_menu.dart';
import '../widgets/welcome_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 70,
        backgroundColor: AppColors.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good morning 👋",
              style: context.textTheme.headlineSmall?.copyWith(
                color: AppColors.white,
              ),
            ),

            Row(
              children: [
                Text(
                  UtilityFile.currentDay(DateTime.now()),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  ", ",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Text(
                  UtilityFile.formatDate(DateTime.now()),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.search_normal_copy,
              size: AppSizes.iconMd,
              color: AppColors.white,
            ),
            onPressed: () {
              //  todo: search function
            },
          ),
          IconButton(
            icon: Icon(
              Iconsax.setting_2_copy,
              size: AppSizes.iconMd,
              color: AppColors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRouteNames.settingsScreen);
            },
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 10),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: AppSizes.md, right: AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(AppSizes.md),

                // Admin Welcome Card
                WelcomeCard(),
                Gap(AppSizes.md),

                Text("Quick Actions", style: context.textTheme.titleLarge),
                Gap(AppSizes.md),

                // Quick Actions
                QuickMenu(),
                Gap(AppSizes.md),

                // Reports
                Text("Reports", style: context.textTheme.titleLarge),
                Gap(AppSizes.md),
                ReportsMenu(),
                Gap(AppSizes.md),

                // Ongoing Works
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ongoing Works", style: context.textTheme.titleLarge),
                    TextButton(onPressed: () {}, child: Text("See all →")),
                  ],
                ),
                Gap(AppSizes.md),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    OngoingWorksCard(),
                    Gap(AppSizes.sm),
                    OngoingWorksCard(),
                  ],
                ),
                Gap(AppSizes.md),

                // Upcoming Banner - Demo purpose
                Text("Upcoming Events", style: context.textTheme.titleLarge),
                Gap(AppSizes.md),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        Color.fromARGB(255, 88, 88, 255),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  padding: EdgeInsets.all(AppSizes.md),
                  child: Column(
                    spacing: AppSizes.xs,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Next Event",
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        "Monthly Payroll Processing",
                        style: context.textTheme.titleLarge?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        "June 30 . End of month",
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(AppSizes.md),
                UpcomingEventBanner(),
                Gap(AppSizes.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
