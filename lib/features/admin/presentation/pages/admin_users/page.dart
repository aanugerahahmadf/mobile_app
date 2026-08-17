import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AdminCrudPage(
      title: l.adminUsers,
      listEndpoint: ApiEndpoints.adminUsers,
      storeEndpoint: ApiEndpoints.adminUsers,
      detailEndpoint: ApiEndpoints.adminUser,
      updateEndpoint: ApiEndpoints.adminUser,
      deleteEndpoint: ApiEndpoints.adminUser,
      imageField: 'avatar_url',
      fields: [FieldConfig('full_name', isTitle: true), FieldConfig('email')],
      transformData: (data) {
        final fn = [
          data['first_name']?.toString().trim() ?? '',
          data['mid_name']?.toString().trim() ?? '',
          data['last_name']?.toString().trim() ?? '',
        ]..removeWhere((s) => s.isEmpty);
        data['full_name'] = fn.join(' ');
        return data;
      },
      formFields: [
        FormFieldConfig(key: 'avatar_url', label: l.profilePhoto, type: FormFieldType.image),
        FormFieldConfig(key: 'first_name', label: l.firstName, required: true),
        FormFieldConfig(key: 'mid_name', label: l.middleName),
        FormFieldConfig(key: 'last_name', label: l.lastName),
        FormFieldConfig(key: 'email', label: l.email, required: true, type: FormFieldType.email),
        FormFieldConfig(key: 'username', label: l.username),
        FormFieldConfig(key: 'password', label: l.password, type: FormFieldType.password),
        FormFieldConfig(key: 'phone', label: l.phoneNumber),
        FormFieldConfig(key: 'whatsapp', label: l.whatsapp),
        FormFieldConfig(key: 'address', label: l.address, type: FormFieldType.multiline),
        FormFieldConfig(key: 'gender', label: l.gender, type: FormFieldType.dropdown, options: [l.male, l.female]),
        FormFieldConfig(key: 'religion', label: l.religion, type: FormFieldType.dropdown, options: [l.islam, l.christian, l.catholic, l.hindu, l.buddha, l.confucian]),
        FormFieldConfig(key: 'birth_place', label: l.placeOfBirth),
        FormFieldConfig(key: 'birth_date', label: l.dateOfBirth),
        FormFieldConfig(key: 'ktp_number', label: l.ktpNumberShort),
        FormFieldConfig(key: 'passport_number', label: l.passportLabel),
        FormFieldConfig(key: 'marital_status', label: l.maritalStatus, type: FormFieldType.dropdown, options: [l.single, l.married, l.divorced]),
        FormFieldConfig(key: 'occupation', label: l.occupation, type: FormFieldType.dropdown, options: [l.employee, l.entrepreneur, l.student, l.housewife, l.professional, l.other]),
        FormFieldConfig(key: 'income_range', label: l.incomeRange, type: FormFieldType.dropdown, options: [l.lessThan1M, l.range1to5M, l.range5to10M, l.range10to50M, l.moreThan50M]),
        FormFieldConfig(key: 'source_of_funds', label: l.sourceOfFunds, type: FormFieldType.dropdown, options: [l.salary, l.business, l.investment, l.gift, l.other]),
        FormFieldConfig(key: 'mother_name', label: l.motherName),
        FormFieldConfig(key: 'identity_type', label: l.identityType, type: FormFieldType.dropdown, options: [l.ktp, l.passportLabel, l.sim, l.npwp]),
        FormFieldConfig(key: 'sim_number', label: l.simNumber),
        FormFieldConfig(key: 'npwp_number', label: l.npwpNumber),
        FormFieldConfig(key: 'ktp_photo', label: l.ktpPhoto, type: FormFieldType.image),
        FormFieldConfig(key: 'selfie_photo', label: l.selfiePhoto, type: FormFieldType.image),
        FormFieldConfig(key: 'budget', label: l.budgetLabel, type: FormFieldType.number),
        FormFieldConfig(key: 'wedding_date', label: l.weddingDateLabel),
        FormFieldConfig(key: 'theme_preference', label: l.themePreference),
        FormFieldConfig(key: 'color_preference', label: l.colorPreference),
        FormFieldConfig(key: 'event_concept', label: l.eventConcept),
        FormFieldConfig(key: 'dream_venue', label: l.dreamVenue),
        FormFieldConfig(key: 'active_status', label: l.activeStatus, type: FormFieldType.toggle),
      ],
    );
  }
}
