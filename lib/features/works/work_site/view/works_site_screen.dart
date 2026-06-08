import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/app_texts.dart';
import 'package:eroll/core/constants/enums.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/works/work_site/provider/view_work_site_provider.dart';
import 'package:eroll/features/works/work_site/view/components/works_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorksSiteScreen extends StatefulWidget {
  const WorksSiteScreen({super.key, this.activeIndex = 0});

  final int activeIndex;

  @override
  State<WorksSiteScreen> createState() => _WorksSiteScreenState();
}

class _WorksSiteScreenState extends State<WorksSiteScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  List<WorkStatus> tabs = [
    WorkStatus.pending,
    WorkStatus.inProgress,
    WorkStatus.completed,
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: widget.activeIndex,
      length: tabs.length,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewWorkSiteProvider>(
        context,
        listen: false,
      ).fetchCreatedWorks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTexts.workSiteText,
          style: TextStyle(fontFamily: 'cabinBold'),
        ),
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRouteNames.createWorkScreen);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              child: Consumer<ViewWorkSiteProvider>(
                builder: (context, viewProvider, _) {
                  return TabBar(
                    isScrollable: true,
                    controller: tabController,
                    indicatorColor: AppColors.primaryColor,
                    labelColor: AppColors.primaryColor,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelColor: AppColors.grey,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,

                    // tabs: tabs.map((e) => Tab(text: e.label)).toList(),
                    tabs: [
                      Tab(
                        text:
                            "${WorkStatus.pending.label} (${viewProvider.pendingWorksList.length})",
                      ),
                      Tab(
                        text:
                            "${WorkStatus.inProgress.label} (${viewProvider.inProgressWorkList.length})",
                      ),
                      Tab(
                        text:
                            "${WorkStatus.completed.label} (${viewProvider.completedWorksList.length})",
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer<ViewWorkSiteProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return TabBarView(
                    controller: tabController,
                    children: [
                      WorksListTileWidget(
                        tabIndex: 0,
                        works: provider.pendingWorksList,
                        workType: WorkStatus.pending.label,
                      ),
                      WorksListTileWidget(
                        tabIndex: 1,
                        works: provider.inProgressWorkList,
                        workType: WorkStatus.inProgress.label,
                      ),
                      WorksListTileWidget(
                        tabIndex: 2,
                        works: provider.completedWorksList,
                        workType: WorkStatus.completed.label,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
