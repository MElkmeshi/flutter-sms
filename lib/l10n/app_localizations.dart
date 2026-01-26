import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS Commands'**
  String get appTitle;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a Service Category'**
  String get selectCategory;

  /// No description provided for @selectCategoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose from banking, telecom, and government services'**
  String get selectCategoryDescription;

  /// No description provided for @selectProvider.
  ///
  /// In en, this message translates to:
  /// **'Select a Service Provider'**
  String get selectProvider;

  /// No description provided for @selectProviderDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose from available service providers'**
  String get selectProviderDescription;

  /// No description provided for @fillForm.
  ///
  /// In en, this message translates to:
  /// **'Fill the Form'**
  String get fillForm;

  /// No description provided for @fillFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete the form below to generate your SMS'**
  String get fillFormDescription;

  /// No description provided for @smsPreview.
  ///
  /// In en, this message translates to:
  /// **'SMS Preview'**
  String get smsPreview;

  /// No description provided for @loadingServices.
  ///
  /// In en, this message translates to:
  /// **'Loading services...'**
  String get loadingServices;

  /// No description provided for @loadingProviders.
  ///
  /// In en, this message translates to:
  /// **'Loading providers...'**
  String get loadingProviders;

  /// No description provided for @noCategorySelected.
  ///
  /// In en, this message translates to:
  /// **'No category selected'**
  String get noCategorySelected;

  /// No description provided for @noCategorySelectedDescription.
  ///
  /// In en, this message translates to:
  /// **'Please go back and select a category first'**
  String get noCategorySelectedDescription;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unknownState.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknownState;

  /// No description provided for @noActionSelected.
  ///
  /// In en, this message translates to:
  /// **'No action selected'**
  String get noActionSelected;

  /// No description provided for @sendSms.
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get sendSms;

  /// No description provided for @smsAppOpenedSuccess.
  ///
  /// In en, this message translates to:
  /// **'SMS app opened successfully!'**
  String get smsAppOpenedSuccess;

  /// No description provided for @smsAppFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open SMS app'**
  String get smsAppFailed;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate SMS commands for various Libyan service providers. Select a category, provider, and action to create your SMS.'**
  String get aboutDescription;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @providers.
  ///
  /// In en, this message translates to:
  /// **'providers'**
  String get providers;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'actions'**
  String get actions;

  /// Enter field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter {field}'**
  String enterField(String field);

  /// Field required error message
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String fieldRequired(String field);

  /// No description provided for @formFields.
  ///
  /// In en, this message translates to:
  /// **'Form Fields'**
  String get formFields;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @savedValues.
  ///
  /// In en, this message translates to:
  /// **'Saved Values'**
  String get savedValues;

  /// No description provided for @noSavedValues.
  ///
  /// In en, this message translates to:
  /// **'No saved values yet'**
  String get noSavedValues;

  /// No description provided for @noSavedValuesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a value and save it for quick access'**
  String get noSavedValuesHint;

  /// No description provided for @saveCurrentValue.
  ///
  /// In en, this message translates to:
  /// **'Save Current Value'**
  String get saveCurrentValue;

  /// No description provided for @valueName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get valueName;

  /// No description provided for @valueNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My Account'**
  String get valueNameHint;

  /// No description provided for @valueNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get valueNameRequired;

  /// No description provided for @deleteSavedValue.
  ///
  /// In en, this message translates to:
  /// **'Delete saved value?'**
  String get deleteSavedValue;

  /// No description provided for @dialUssd.
  ///
  /// In en, this message translates to:
  /// **'Dial USSD'**
  String get dialUssd;

  /// No description provided for @ussdPreview.
  ///
  /// In en, this message translates to:
  /// **'USSD Preview'**
  String get ussdPreview;

  /// No description provided for @ussdDialerOpenedSuccess.
  ///
  /// In en, this message translates to:
  /// **'USSD dialer opened successfully!'**
  String get ussdDialerOpenedSuccess;

  /// No description provided for @ussdDialerFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open USSD dialer'**
  String get ussdDialerFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
