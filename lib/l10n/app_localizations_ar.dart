// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أوامر الرسائل النصية';

  @override
  String get selectCategory => 'اختر فئة الخدمة';

  @override
  String get selectCategoryDescription => 'اختر من خدمات البنوك والاتصالات والحكومة';

  @override
  String get selectProvider => 'اختر مزود الخدمة';

  @override
  String get selectProviderDescription => 'اختر من مزودي الخدمات المتاحة';

  @override
  String get fillForm => 'املأ النموذج';

  @override
  String get fillFormDescription => 'أكمل النموذج أدناه لإنشاء رسالتك النصية';

  @override
  String get smsPreview => 'معاينة الرسالة';

  @override
  String get loadingServices => 'جاري تحميل الخدمات...';

  @override
  String get loadingProviders => 'جاري تحميل المزودين...';

  @override
  String get noCategorySelected => 'لم يتم اختيار فئة';

  @override
  String get noCategorySelectedDescription => 'يرجى العودة واختيار فئة أولاً';

  @override
  String get goBack => 'العودة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get error => 'خطأ';

  @override
  String get unknownState => 'حالة غير معروفة';

  @override
  String get noActionSelected => 'لم يتم اختيار إجراء';

  @override
  String get sendSms => 'إرسال الرسالة';

  @override
  String get smsAppOpenedSuccess => 'تم فتح تطبيق الرسائل بنجاح!';

  @override
  String get smsAppFailed => 'فشل في فتح تطبيق الرسائل';

  @override
  String get about => 'حول';

  @override
  String get aboutDescription => 'إنشاء أوامر رسائل نصية لمختلف مزودي الخدمات الليبيين. اختر فئة ومزود وإجراء لإنشاء رسالتك النصية.';

  @override
  String get ok => 'موافق';

  @override
  String get providers => 'مزودين';

  @override
  String get actions => 'إجراءات';

  @override
  String enterField(String field) {
    return 'أدخل $field';
  }

  @override
  String fieldRequired(String field) {
    return '$field مطلوب';
  }

  @override
  String get formFields => 'حقول النموذج';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get saved => 'محفوظ';

  @override
  String get savedValues => 'القيم المحفوظة';

  @override
  String get noSavedValues => 'لا توجد قيم محفوظة بعد';

  @override
  String get noSavedValuesHint => 'أدخل قيمة واحفظها للوصول السريع';

  @override
  String get saveCurrentValue => 'حفظ القيمة الحالية';

  @override
  String get valueName => 'الاسم';

  @override
  String get valueNameHint => 'مثال: حسابي';

  @override
  String get valueNameRequired => 'الاسم مطلوب';

  @override
  String get deleteSavedValue => 'حذف القيمة المحفوظة؟';

  @override
  String get dialUssd => 'طلب USSD';

  @override
  String get ussdPreview => 'معاينة كود USSD';

  @override
  String get ussdDialerOpenedSuccess => 'تم فتح طالب USSD بنجاح!';

  @override
  String get ussdDialerFailed => 'فشل في فتح طالب USSD';
}
