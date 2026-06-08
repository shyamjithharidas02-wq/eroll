import 'dart:developer';

import 'package:eroll/core/widgets/button_widget.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/data_constants.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/features/create_staff/model/create_staff_model.dart';
import 'package:eroll/features/create_staff/provider/create_staff_provider.dart';
import 'package:eroll/features/staffs/provider/view_staff_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateStaffScreen extends StatefulWidget {
  final bool isEditMode;
  final CreateStaffModel? staffData;

  const CreateStaffScreen({
    super.key,
    required this.isEditMode,
    this.staffData,
  });

  @override
  State<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends State<CreateStaffScreen> {
  String? selectedValue;
  late final TextEditingController nameController;
  late final TextEditingController mobileController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    mobileController = TextEditingController();

    _populateFieldsIfEditing();
  }

  void _populateFieldsIfEditing() {
    if (widget.isEditMode && widget.staffData != null) {
      try {
        final staff = widget.staffData;

        nameController.text = staff?.name ?? '';
        mobileController.text = staff?.mobile ?? '';
        selectedValue = staff?.empType;

        log('Edit mode - populated fields for: ${staff?.name}');
      } catch (e) {
        log('Error populating fields: $e');
        // Reset to empty values on error
        nameController.text = '';
        mobileController.text = '';
        selectedValue = null;
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'Edit Staff' : 'Add Staff',
          style: const TextStyle(fontFamily: 'cabinBold'),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Employee name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Staff Name'),
              ),
              const SizedBox(height: 20),

              // Employee phone number
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Phone Number')),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 20),

              // Employee type - dropdown
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        items:
                            DataConstants.employeeType
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                })
                                .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                        hint: const Text('Select Work Mode'),
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Create/Update button
              Consumer<CreateStaffProvider>(
                builder: (context, createStaffProvider, _) {
                  return ButtonWidget(
                    btnText: widget.isEditMode ? 'Update' : 'Create',
                    btnColor: AppColors.primaryColor,
                    isLoading: createStaffProvider.isLoading,
                    btnAction: () => _handleSubmit(createStaffProvider),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(CreateStaffProvider createStaffProvider) async {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();

    // Validation
    if (name.isEmpty || mobile.isEmpty || selectedValue == null) {
      UtilityFile.showSnackBar('All fields are mandatory', context);
      return;
    }

    if (name.length < 3) {
      UtilityFile.showSnackBar('Name must be at least 3 characters', context);
      return;
    }

    try {
      if (widget.isEditMode && widget.staffData != null) {
        // Update existing staff
        final staffId = widget.staffData!.staffId;
        if (staffId.isEmpty) {
          throw Exception('Invalid staff ID');
        }

        await context.read<ViewStaffProvider>().updateStaff(
          staffId: staffId,
          name: name,
          mobile: mobile,
          empType: selectedValue!,
        );

        if (!mounted) return;
        UtilityFile.showSnackBar('Staff updated successfully', context);
      } else {
        // Create new staff
        await createStaffProvider.addStaff(
          name: name,
          mobile: mobile,
          empType: selectedValue!,
        );

        if (!mounted) return;
        UtilityFile.showSnackBar('Staff added successfully', context);
      }

      // Refresh the staff list
      if (mounted) {
        context.read<ViewStaffProvider>().fetchStaffs();
        Navigator.pop(context);
      }
    } catch (e) {
      log('Error in _handleSubmit: $e');
      if (!mounted) return;
      UtilityFile.showSnackBar('An error occurred. Please try again.', context);
    }
  }
}
