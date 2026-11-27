import 'package:eroll/core/widgets/button_widget.dart';
import 'package:eroll/core/widgets/custom_back_button_appbar.dart';
import 'package:eroll/core/widgets/custom_title_appbar.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/data_constants.dart';
import 'package:flutter/material.dart';

class AddSalaryScreen extends StatelessWidget {
  AddSalaryScreen({super.key});

  final value = DataConstants.checkListEmployees.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButtonAppbar(),
        title: const CustomTitleAppbar(appBarTitle: 'Add Salary'),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          spacing: 12.0,
          children: [
            // Amount Field
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),

            // Select Staff
            DropdownButtonFormField(
              hint: const Text('Select Staff'),
              //value: value,
              items: DataConstants.checkListEmployees
                  .map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(value: e, child: Text(e));
                  })
                  .toList(),
              onChanged: (value) {},
            ),

            // Salary Type - Advance | Net
            DropdownButtonFormField(
              hint: const Text('Salary Type'),
              items: DataConstants.salaryType.map<DropdownMenuItem<String>>((
                e,
              ) {
                return DropdownMenuItem<String>(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {},
            ),

            // Date

            // Button
            ButtonWidget(
              btnText: 'Add',
              btnColor: AppColors.primary,
              btnAction: () {
                // todo: add salary function
              },
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}
