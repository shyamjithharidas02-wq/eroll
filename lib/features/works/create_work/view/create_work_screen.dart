import 'package:eroll/core/widgets/button_widget.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/features/works/create_work/provider/create_work_provider.dart';
import 'package:eroll/features/works/create_work/validators/input_validators.dart';
import 'package:eroll/features/works/work_site/provider/view_work_site_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/custom_form_label.dart';

class CreateWorkScreen extends StatefulWidget {
  const CreateWorkScreen({super.key});

  @override
  State<CreateWorkScreen> createState() => _CreateWorkScreenState();
}

class _CreateWorkScreenState extends State<CreateWorkScreen> {
  final workSiteController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<CreateWorkProvider>(context, listen: false);
      provider.fetchStaffs(context);
    });
  }

  @override
  void dispose() {
    workSiteController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back),
        ),
        title: Text('Create Work', style: TextStyle(fontFamily: 'cabinBold')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // work site name field
                CustomFormLabel(labelText: 'Work Site'),
                SizedBox(height: 5),
                TextFormField(
                  controller: workSiteController,
                  minLines: 1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.grey400),
                    ),
                  ),
                  validator: InputValidators.validateName,
                ),
                SizedBox(height: 20),

                // description field
                CustomFormLabel(labelText: 'Description', isMandatory: false),
                SizedBox(height: 5),
                TextField(
                  controller: descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.grey400),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Start Date
                CustomFormLabel(labelText: 'Start Date'),
                SizedBox(height: 5),
                Consumer<CreateWorkProvider>(
                  builder:
                      (context, workProvider, _) => GestureDetector(
                        onTap: () async {
                          final selectDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2100),
                            currentDate: DateTime.now(),
                            builder:
                                (context, child) => Theme(
                                  data: Theme.of(context).copyWith(
                                    dialogTheme: DialogThemeData(
                                      backgroundColor: AppColors.white,
                                    ),
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors.primaryColor,
                                    ),
                                  ),
                                  child: child!,
                                ),
                          );

                          if (selectDate != null) {
                            workProvider.setStartDate(selectDate);
                          }
                        },
                        child: Container(
                          height: 55.0,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                workProvider.startDate != null
                                    ? UtilityFile.formatDateMonthYear(
                                      workProvider.startDate!,
                                    )
                                    : 'Select start date',
                              ),
                              Icon(CupertinoIcons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                ),
                SizedBox(height: 20),

                // Add people
                CustomFormLabel(labelText: 'Add Team'),
                SizedBox(height: 5),
                Consumer<CreateWorkProvider>(
                  builder: (context, provider, _) {
                    return GestureDetector(
                      onTap: () => showPopup(),
                      child: Container(
                        height: 55.0,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.selectedTeamMember.isEmpty
                                  ? "Select Team Members"
                                  : "${provider.selectedTeamMember.length} member selected",
                            ),
                            Icon(CupertinoIcons.person_3_fill),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40),

                // Button
                Consumer<CreateWorkProvider>(
                  builder:
                      (context, provider, _) => ButtonWidget(
                        btnText: 'Create Work',
                        btnColor: AppColors.primaryColor,
                        btnAction: () async {
                          final workSiteName = workSiteController.text.trim();
                          final description = descriptionController.text;

                          if (workSiteName.isEmpty ||
                              provider.startDate == null ||
                              provider.selectedTeamMember.isEmpty) {
                            UtilityFile.showSnackBar(
                              'Please fill mandatory fields',
                              context,
                            );
                            return;
                          }

                          await provider.createWork(
                            workSiteName: workSiteName,
                            workDescription: description,
                            startDate: provider.startDate!,
                            teamMembers: provider.selectedTeamMember,
                          );

                          if (!mounted) return;

                          WidgetsBinding.instance.addPostFrameCallback((
                            _,
                          ) async {
                            UtilityFile.showSnackBar(
                              'Work created successfully',
                              context,
                            );

                            Navigator.pop(context, true);

                            await Provider.of<ViewWorkSiteProvider>(
                              context,
                              listen: false,
                            ).fetchCreatedWorks();
                          });
                        },
                        isLoading: provider.isLoading,
                      ),
                ),
              ],
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
        final provider = Provider.of<CreateWorkProvider>(
          context,
          listen: false,
        );

        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Consumer<CreateWorkProvider>(
                builder: (context, value, child) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.staffsList.length,
                      itemBuilder: (context, index) {
                        final staff = provider.staffsList[index];

                        return CheckboxListTile(
                          title: Text(staff.name),
                          value: provider.isStaffMemberSelected(staff),
                          onChanged: (value) {
                            provider.selectStaffMember(staff);
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
