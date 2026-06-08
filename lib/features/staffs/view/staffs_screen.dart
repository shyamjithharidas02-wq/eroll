import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/app_texts.dart';
import 'package:eroll/core/constants/resource_path.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/staffs/provider/view_staff_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/dialog_textbutton.dart';
import 'components/empty_staff_widget.dart';

class StaffsScreen extends StatefulWidget {
  const StaffsScreen({super.key});

  @override
  State<StaffsScreen> createState() => _StaffsScreenState();
}

class _StaffsScreenState extends State<StaffsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<ViewStaffProvider>().fetchStaffs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        scrolledUnderElevation: 5,
        title: Text('Staffs', style: TextStyle(fontFamily: 'cabinBold')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRouteNames.createStaffScreen);
            },
            icon: Icon(CupertinoIcons.add),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 20),
      ),
      body: SafeArea(
        child: Consumer<ViewStaffProvider>(
          builder: (context, viewStaffProvider, _) {
            if (viewStaffProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (viewStaffProvider.viewStaffList.isEmpty) {
              return EmptyStaffWidget(
                image: AssetPath.emptyListImage,
                label: AppTexts.emptyStaffText,
              );
            }

            return ListView.builder(
              itemCount: viewStaffProvider.viewStaffList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final staffs = viewStaffProvider.viewStaffList[index];

                return Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.strokeColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(
                          AssetPath.profileCircleVector,
                        ),
                      ),
                      SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              staffs.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'cabinBold'),
                            ),
                            Text(
                              staffs.empType,
                              style: TextStyle(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouteNames.createStaffScreen,
                            arguments: staffs,
                          );
                        },
                        child: Icon(CupertinoIcons.pencil),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: Text('Delete Staff'),
                                  content: Text(
                                    'Are you sure you want to delete this staff member?',
                                  ),
                                  actions: [
                                    DialogTextButton(
                                      label: 'Cancel',
                                      onTap:
                                          () => Navigator.pop(context, false),
                                    ),
                                    DialogTextButton(
                                      label: 'Delete',
                                      onTap: () => Navigator.pop(context, true),
                                    ),
                                  ],
                                  backgroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                          );

                          if (confirm == true) {
                            await viewStaffProvider
                                .deleteStaff(staffs.staffId)
                                .then((value) async {
                                  await viewStaffProvider.fetchStaffs();
                                });

                            if (!mounted) return;
                            UtilityFile.showSnackBar(
                              '${staffs.name} deleted',
                              context,
                            );
                            //todo: find the appropriate solution for this
                          }
                        },
                        child: Icon(
                          CupertinoIcons.delete,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            );
          },
        ),
      ),
    );
  }
}
