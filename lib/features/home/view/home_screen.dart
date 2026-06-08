import 'package:eroll/core/widgets/custom_padding_widget.dart';
import 'package:eroll/core/constants/resource_path.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/home/view/components/in_progress_title_widget.dart';
import 'package:eroll/features/home/view/components/in_progress_work_card_widget.dart';
import 'package:eroll/features/home/view/components/report_card_widget.dart';
import 'package:eroll/features/home/view/components/search_widget.dart';
import 'package:eroll/features/home/view/components/shortcut_menu.dart';
import 'package:eroll/features/upcoming_event/view/upcoming_event_banner.dart';
import 'package:eroll/features/works/work_site/provider/view_work_site_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ViewWorkSiteProvider>(
        context,
        listen: false,
      ).fetchCreatedWorks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewWorkProvider = Provider.of<ViewWorkSiteProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              UtilityFile.formatDate(DateTime.now()),
              style: TextStyle(fontFamily: 'cabinBold'),
            ),
            Text(
              UtilityFile.currentDay(DateTime.now()),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, AppRouteNames.settingsScreen);
            },
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 10),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),

                // Search
                CustomPaddingWidget(
                  pLeft: 20,
                  pRight: 20,
                  child: SearchWidget(),
                ),

                // InProgress Work Title
                if (viewWorkProvider.inProgressWorkList.isNotEmpty) ...[
                  SizedBox(height: 30),
                  CustomPaddingWidget(
                    pLeft: 20,
                    pRight: 20,
                    child: InProgressTitleWidget(),
                  ),
                ],
                SizedBox(height: 10),

                // InProgress Work Card
                if (viewWorkProvider.inProgressWorkList.isNotEmpty)
                  Consumer<ViewWorkSiteProvider>(
                    builder: (context, viewWorkProvider, _) {
                      return SizedBox(
                        height: 170,
                        child: ListView.builder(
                          itemCount: viewWorkProvider.inProgressWorkList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final inProgressWorks =
                                viewWorkProvider.inProgressWorkList[index];

                            return InProgressWorkCardWidget(
                              inProgressWorks: inProgressWorks,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(right: 20),
                        ),
                      );
                    },
                  ),
                SizedBox(height: 30),

                // Shortcut Menu
                CustomPaddingWidget(
                  pLeft: 20,
                  pRight: 20,
                  child: ShortcutMenu(),
                ),
                SizedBox(height: 20),

                // Reports - Section
                CustomPaddingWidget(
                  pLeft: 20,
                  child: Text(
                    'Reports',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                SizedBox(height: 10),

                // Payroll Ledger Report
                ReportCardWidget(
                  imagePath: AssetPath.payrollImage,
                  labelText: 'Payroll Ledger Report',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouteNames.payrollMonthListScreen,
                      arguments: false,
                    );
                  },
                ),
                SizedBox(height: 10),

                // Attendance Report
                ReportCardWidget(
                  imagePath: AssetPath.attendanceImage,
                  labelText: 'Attendance Report',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouteNames.attendanceReportScreen,
                    );
                  },
                ),
                SizedBox(height: 10),

                // Staff Payroll Report
                ReportCardWidget(
                  imagePath: AssetPath.employeePayrollImage,
                  labelText: 'Staff Payroll Report',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouteNames.staffListPayrollScreen,
                    );
                  },
                ),
                SizedBox(height: 20),

                // Upcoming Banner - Demo purpose
                CustomPaddingWidget(
                  pLeft: 20,
                  child: Text(
                    'Upcoming Events',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                SizedBox(height: 20),

                // Card - Banner
                UpcomingEventBanner(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
