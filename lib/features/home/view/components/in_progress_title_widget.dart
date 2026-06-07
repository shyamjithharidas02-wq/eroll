import 'package:eroll/core/constants/app_colors.dart';
import 'package:eroll/core/constants/app_texts.dart';
import 'package:eroll/core/routes/app_route_names.dart';
import 'package:eroll/features/works/work_site/provider/view_work_site_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InProgressTitleWidget extends StatefulWidget {
  const InProgressTitleWidget({super.key});

  @override
  State<InProgressTitleWidget> createState() => _InProgressTitleWidgetState();
}

class _InProgressTitleWidgetState extends State<InProgressTitleWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewWorkSiteProvider>(
        context,
        listen: false,
      ).fetchCreatedWorks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 10,
          children: [
            Text(
              AppTexts.inProgressHeader,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            Consumer<ViewWorkSiteProvider>(
              builder: (context, viewWorkProvider, _) {
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),

                  child: Text(
                    viewWorkProvider.inProgressWorkList.length.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'cabinBold',
                      color: AppColors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouteNames.siteWorksScreen,
              arguments: 1,
            );
          },
          child: Text(
            AppTexts.seeAllText,
            style: TextStyle(
              color: AppColors.grey,
              //fontFamily: 'cabinBold',
            ),
          ),
        ),
      ],
    );
  }
}
