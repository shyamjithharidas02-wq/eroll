import 'dart:developer';

import 'package:eroll/components/button_widget.dart';
import 'package:eroll/core/constants/app_colors.dart';
import 'package:eroll/core/constants/enums.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/features/create_staff/model/create_staff_model.dart';
import 'package:eroll/features/works/create_work/model/create_work_model.dart';
import 'package:eroll/features/works/create_work/view/components/work_end_date_widget.dart';
import 'package:eroll/features/works/create_work/view/components/work_start_date_widget.dart';
import 'package:eroll/features/works/update_work/provider/update_work_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../work_site/provider/view_work_site_provider.dart';

class UpdateWorkStatusScreen extends StatefulWidget {
  final CreateWorkModel workModel;

  const UpdateWorkStatusScreen({super.key, required this.workModel});

  @override
  State<UpdateWorkStatusScreen> createState() => _UpdateWorkStatusScreenState();
}

class _UpdateWorkStatusScreenState extends State<UpdateWorkStatusScreen> {
  final siteNameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? workCreatedDate;
  WorkStatus? status;
  List<CreateStaffModel>? team;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _populateFieldsIfEditing();
    _isInitializeProvider();
  }

  void _populateFieldsIfEditing() {
    try {
      final model = widget.workModel;
      siteNameController.text = model.workSiteName;
      descriptionController.text = model.workDescription;
      workCreatedDate = model.startDate;
      status = model.status;
      team =
          model.assignedEmployeesList
              .map(
                (e) => CreateStaffModel.fromMap(Map<String, dynamic>.from(e)),
              )
              .toList();

      log('sitename: ${siteNameController.text}');
      log('desciption: ${descriptionController.text}');
      log('start date: $workCreatedDate');
      log('team: $team');
      log('status: $status');
    } catch (e) {
      log('Error populating fields: $e');
    }
  }

  void _isInitializeProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final updateProvider = Provider.of<UpdateWorkProvider>(
        context,
        listen: false,
      );

      updateProvider.initializeSelectedStaffs(team ?? []);

      // end date if available
      if (widget.workModel.endDate != null) {
        updateProvider.setWorkEndDate(widget.workModel.endDate!);
      }

      // available staffs
      await updateProvider.fetchAvailableStaffs(context);

      updateProvider.matchExistingTeamMember(team ?? []);

      setState(() {
        isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) =>
    //       Provider.of<UpdateWorkProvider>(context, listen: false).clearData(),
    // );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Work')),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Work/Place
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.grey400),
                      ),
                    ),
                    child: TextField(
                      minLines: 1,
                      maxLines: 2,
                      controller: siteNameController,
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Work/Place Name',
                      ),
                    ),
                  ),

                  // Work Description
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.grey400),
                      ),
                    ),
                    child: TextField(
                      maxLines: 8,
                      controller: descriptionController,
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Description',
                      ),
                    ),
                  ),

                  // Started Date
                  WorkStartDateWidget(
                    dateLabel: 'Start Date',
                    startDate: workCreatedDate!,
                  ),

                  // End Date
                  WorkEndDateWidget(),

                  // Work Status
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.grey400),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.alarm),
                        SizedBox(width: 10),
                        Text('Status'),
                        Spacer(),
                        Expanded(
                          child: Consumer<UpdateWorkProvider>(
                            builder:
                                (context, provider, _) =>
                                    DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField<String>(
                                        value: status!.label,
                                        items:
                                            WorkStatus.values.map((element) {
                                              return DropdownMenuItem<String>(
                                                value: element.label,
                                                child: Text(element.label),
                                              );
                                            }).toList(),
                                        onChanged: (value) {
                                          status = WorkStatus.values.firstWhere(
                                            (element) => element.label == value,
                                            orElse: () => WorkStatus.pending,
                                          );

                                          provider.setUpdateWorkStatus(
                                            status!.name,
                                          );
                                        },
                                        decoration: InputDecoration.collapsed(
                                          hintText: '',
                                        ),
                                        hint: Text('Status'),
                                        dropdownColor: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Assigned People List
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.grey400),
                      ),
                    ),
                    child: Consumer<UpdateWorkProvider>(
                      builder:
                          (context, updateProvider, _) => Row(
                            children: [
                              Icon(CupertinoIcons.person_2),
                              SizedBox(width: 10),
                              Text('Team Members'),
                              Spacer(),
                              GestureDetector(
                                onTap: () => isInitialized ? showPopup() : null,
                                child: Row(
                                  children: [
                                    Text(
                                      '${updateProvider.selectedStaffs.length} Members',
                                    ),
                                    Icon(
                                      Icons.keyboard_double_arrow_down_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),

                  Consumer<UpdateWorkProvider>(
                    builder:
                        (context, updateProvider, child) => CheckboxListTile(
                          title: Text('Completed work'),
                          value: updateProvider.isWorkCompletedFlag,
                          onChanged: (value) {
                            updateProvider.workCompletedStatus(true);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          checkColor: AppColors.white,
                          activeColor: AppColors.primaryColor,
                        ),
                  ),

                  SizedBox(height: 40),

                  // Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Consumer<UpdateWorkProvider>(
                      builder: (context, updateProvider, _) {
                        return ButtonWidget(
                          btnText: 'Update',
                          btnColor: AppColors.primaryColor,
                          isLoading: updateProvider.isLoading,
                          btnAction: () async {
                            await updateProvider.updateWork(
                              workId: widget.workModel.workId,
                              title: siteNameController.text,
                              description: descriptionController.text,
                              startDate: workCreatedDate!,
                              status: status!.name,
                              endDate: updateProvider.endDate,
                              isWorkCompleted:
                                  updateProvider.isWorkCompletedFlag,
                            );

                            if (!mounted) return;

                            // Optionally show success message
                            WidgetsBinding.instance.addPostFrameCallback((
                              _,
                            ) async {
                              UtilityFile.showSnackBar(
                                'Work updated successfully',
                                context,
                              );
                              Navigator.pop(context);

                              await Provider.of<ViewWorkSiteProvider>(
                                context,
                                listen: false,
                              ).fetchCreatedWorks();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showPopup() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Consumer<UpdateWorkProvider>(
                builder: (context, updateProvider, _) {
                  if (updateProvider.allStaffs.isEmpty) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: updateProvider.allStaffs.length,
                      itemBuilder: (context, index) {
                        final staff = updateProvider.allStaffs[index];
                        return CheckboxListTile(
                          title: Text(staff.name),
                          value: updateProvider.isStaffSelected(staff),
                          onChanged: (value) {
                            updateProvider.updateAssignedStaffs(staff);
                          },
                          activeColor: AppColors.primaryColor,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColors.black)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Ok',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
