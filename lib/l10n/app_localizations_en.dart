// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SMS Commands';

  @override
  String get selectCategory => 'Select a Service Category';

  @override
  String get selectCategoryDescription => 'Choose from banking, telecom, and government services';

  @override
  String get selectProvider => 'Select a Service Provider';

  @override
  String get selectProviderDescription => 'Choose from available service providers';

  @override
  String get fillForm => 'Fill the Form';

  @override
  String get fillFormDescription => 'Complete the form below to generate your SMS';

  @override
  String get smsPreview => 'SMS Preview';

  @override
  String get loadingServices => 'Loading services...';

  @override
  String get loadingProviders => 'Loading providers...';

  @override
  String get noCategorySelected => 'No category selected';

  @override
  String get noCategorySelectedDescription => 'Please go back and select a category first';

  @override
  String get goBack => 'Go Back';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get unknownState => 'Unknown state';

  @override
  String get noActionSelected => 'No action selected';

  @override
  String get sendSms => 'Send SMS';

  @override
  String get smsAppOpenedSuccess => 'SMS app opened successfully!';

  @override
  String get smsAppFailed => 'Failed to open SMS app';

  @override
  String get about => 'About';

  @override
  String get aboutDescription => 'Generate SMS commands for various Libyan service providers. Select a category, provider, and action to create your SMS.';

  @override
  String get ok => 'OK';

  @override
  String get providers => 'providers';

  @override
  String get actions => 'actions';

  @override
  String enterField(String field) {
    return 'Enter $field';
  }

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get formFields => 'Form Fields';

  @override
  String get clearAll => 'Clear All';

  @override
  String get saved => 'Saved';

  @override
  String get savedValues => 'Saved Values';

  @override
  String get noSavedValues => 'No saved values yet';

  @override
  String get noSavedValuesHint => 'Enter a value and save it for quick access';

  @override
  String get saveCurrentValue => 'Save Current Value';

  @override
  String get addNewValue => 'Add New Value';

  @override
  String get value => 'Value';

  @override
  String get valueName => 'Name';

  @override
  String get valueNameHint => 'e.g. My Account';

  @override
  String get valueNameRequired => 'Name is required';

  @override
  String get deleteSavedValue => 'Delete saved value?';

  @override
  String get dialUssd => 'Dial USSD';

  @override
  String get ussdPreview => 'USSD Preview';

  @override
  String get ussdDialerOpenedSuccess => 'USSD dialer opened successfully!';

  @override
  String get ussdDialerFailed => 'Failed to open USSD dialer';

  @override
  String get search => 'Search';

  @override
  String get noSearchResults => 'No results found';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get manageSavedValues => 'Manage saved values';

  @override
  String get editValueName => 'Edit Value Name';

  @override
  String get save => 'Save';

  @override
  String get valueSaved => 'Value saved successfully';

  @override
  String saveValuePrompt(String field) {
    return 'Save $field for next time?';
  }
}
