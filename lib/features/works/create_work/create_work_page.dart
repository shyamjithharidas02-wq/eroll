import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/widgets/circle_back_top_bar.dart';
import '../work_site/data/models/site_model.dart';
import '../work_site/widgets/site_status_switcher.dart';
import 'widgets/form_widgets.dart';

/// "New site" form. Pops with the created [SiteModel] on success.
class CreateWorkPage extends StatefulWidget {
  const CreateWorkPage({super.key});

  @override
  State<CreateWorkPage> createState() => _CreateWorkPageState();
}

class _CreateWorkPageState extends State<CreateWorkPage> {
  static const double _hPad = 20;
  static const _workTypes = [
    'Borewell',
    'Open well',
    'Ring well',
    'Cleaning',
    'Deepening',
    'Pump fitting',
  ];
  static const _statusLabels = ['To do', 'Ongoing', 'Done'];
  static final _dateFormat = DateFormat('EEE, d MMM yyyy');

  final _formKey = GlobalKey<FormState>();
  final _siteName = TextEditingController();
  final _location = TextEditingController();
  final _clientName = TextEditingController();
  final _phone = TextEditingController();
  final _quoted = TextEditingController();
  final _advance = TextEditingController();
  final _startDateText = TextEditingController();

  String? _workType;
  DateTime _startDate = DateUtils.dateOnly(DateTime.now());
  SiteStatus _status = SiteStatus.todo;

  @override
  void initState() {
    super.initState();
    _startDateText.text = _dateFormat.format(_startDate);
  }

  @override
  void dispose() {
    for (final c in [
      _siteName,
      _location,
      _clientName,
      _phone,
      _quoted,
      _advance,
      _startDateText,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme
              .copyWith(primary: AppColors.pine, onPrimary: AppColors.white),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      _startDate = picked;
      _startDateText.text = _dateFormat.format(picked);
    });
  }

  String? _required(String? value, String message) =>
      (value == null || value.trim().isEmpty) ? message : null;

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_workType == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pick the type of work')));
      return;
    }

    final site = SiteModel(
      title: _siteName.text.trim(),
      location: _location.text.trim(),
      startDate: _startDate,
      status: _status,
      workType: _workType,
      recentAmount: 0,
      received: RupeeInputFormatter.parse(_advance.text),
      contractValue: RupeeInputFormatter.parse(_quoted.text),
      workersToday: 0,
      clientName: _clientName.text.trim().isEmpty
          ? null
          : _clientName.text.trim(),
      clientPhone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
    );
    // TODO: persist the site to Firestore.
    Navigator.pop(context, site);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = media.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  _hPad,
                  media.padding.top + 12,
                  _hPad,
                  bottomInset + 110,
                ),
                children: [
                  const CircleBackTopBar(title: 'New site'),
                  const Gap(24),

                  const FormSectionLabel('Job'),
                  FormCard(
                    children: [
                      FormInputField(
                        label: 'Site name',
                        controller: _siteName,
                        hint: 'e.g. Mathew’s borewell',
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => _required(v, 'Enter a site name'),
                      ),
                      const FieldGap(),
                      const FieldLabel('Type of work'),
                      ChoiceChips(
                        options: _workTypes,
                        selected: _workType,
                        onSelected: (v) => setState(() => _workType = v),
                      ),
                      const FieldGap(),
                      FormInputField(
                        label: 'Location',
                        controller: _location,
                        hint: 'Village, landmark',
                        textCapitalization: TextCapitalization.sentences,
                        prefixIcon: const Icon(
                          Iconsax.location_copy,
                          size: 22,
                          color: AppColors.pine,
                        ),
                        validator: (v) => _required(v, 'Enter the location'),
                      ),
                    ],
                  ),
                  const Gap(28),

                  const FormSectionLabel('Client'),
                  FormCard(
                    children: [
                      FormInputField(
                        label: 'Client name',
                        controller: _clientName,
                        hint: 'Who is paying',
                        textCapitalization: TextCapitalization.words,
                      ),
                      const FieldGap(),
                      FormInputField(
                        label: 'Phone',
                        controller: _phone,
                        hint: '10-digit number',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]')),
                          LengthLimitingTextInputFormatter(15),
                        ],
                      ),
                    ],
                  ),
                  const Gap(28),

                  const FormSectionLabel('Money'),
                  FormCard(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormInputField(
                              label: 'Quoted amount',
                              controller: _quoted,
                              hint: '₹0',
                              boldValue: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [RupeeInputFormatter()],
                              validator: (v) =>
                                  RupeeInputFormatter.parse(v ?? '') <= 0
                                  ? 'Enter amount'
                                  : null,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: FormInputField(
                              label: 'Advance received',
                              controller: _advance,
                              hint: '₹0',
                              boldValue: true,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [RupeeInputFormatter()],
                              validator: (v) {
                                final advance = RupeeInputFormatter.parse(
                                  v ?? '',
                                );
                                final quoted = RupeeInputFormatter.parse(
                                  _quoted.text,
                                );
                                return quoted > 0 && advance > quoted
                                    ? 'More than quote'
                                    : null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(28),

                  const FormSectionLabel('Schedule'),
                  FormCard(
                    children: [
                      FormInputField(
                        label: 'Start date',
                        controller: _startDateText,
                        readOnly: true,
                        onTap: _pickStartDate,
                      ),
                      const FieldGap(),
                      const FieldLabel('Status'),
                      SiteStatusSwitcher(
                        labels: _statusLabels,
                        selectedIndex: _status.index,
                        onChanged: (i) =>
                            setState(() => _status = SiteStatus.values[i]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: _hPad,
              right: _hPad,
              bottom: bottomInset + 16,
              child: _CreateButton(onTap: _submit),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(29),
        child: InkWell(
          borderRadius: BorderRadius.circular(29),
          onTap: onTap,
          child: SizedBox(
            height: 58,
            child: Center(
              child: Text(
                'Create site',
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 17,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
