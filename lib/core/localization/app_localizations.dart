import 'package:flutter/material.dart';
import 'app_strings.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ar', ''),
    Locale('en', ''),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      AppStrings.appName: 'Nutrition & Diet Clinic',
      AppStrings.cancel: 'Cancel',
      AppStrings.confirm: 'Confirm',
      AppStrings.save: 'Save',
      AppStrings.submit: 'Submit',
      AppStrings.delete: 'Delete',
      AppStrings.retry: 'Retry',
      AppStrings.back: 'Back',
      AppStrings.next: 'Next',
      AppStrings.loading: 'Loading...',
      AppStrings.success: 'Success',
      AppStrings.error: 'Error occurred',
      AppStrings.viewAll: 'View All',
      AppStrings.details: 'Details',
      AppStrings.date: 'Date',
      AppStrings.status: 'Status',
      AppStrings.active: 'Active',
      AppStrings.inactive: 'Inactive',
      AppStrings.pending: 'Pending',
      AppStrings.demoMode: 'Demo Testing Panel',
      AppStrings.demoTestingTools: 'Demo Control Tools',

      // Auth
      AppStrings.loginTitle: 'Welcome Back',
      AppStrings.loginSubtitle: 'Sign in to access your nutrition plan and progress',
      AppStrings.emailOrPhone: 'Email or Phone Number',
      AppStrings.password: 'Password',
      AppStrings.rememberMe: 'Remember me',
      AppStrings.forgotPassword: 'Forgot password?',
      AppStrings.forgotPasswordTitle: 'Reset Password',
      AppStrings.forgotPasswordDesc: 'Enter your email to receive recovery instructions',
      AppStrings.sendResetLink: 'Send Reset Link',
      AppStrings.resetLinkSent: 'Reset instructions sent to your email (Simulated)',
      AppStrings.login: 'Sign In',
      AppStrings.donotHaveAccount: "Don't have an account?",
      AppStrings.createAccount: 'Register Online',
      AppStrings.registerTitle: 'Create Online Account',
      AppStrings.registerSubtitle: 'Start your healthy lifestyle journey today',
      AppStrings.fullName: 'Full Name',
      AppStrings.email: 'Email Address',
      AppStrings.phone: 'Phone Number',
      AppStrings.gender: 'Gender',
      AppStrings.male: 'Male',
      AppStrings.female: 'Female',
      AppStrings.age: 'Age (Years)',
      AppStrings.height: 'Height (cm)',
      AppStrings.currentWeight: 'Current Weight (kg)',
      AppStrings.targetWeight: 'Target Weight (kg)',
      AppStrings.mainGoal: 'Main Fitness Goal',
      AppStrings.goalWeightLoss: 'Weight Loss & Fat Reduction',
      AppStrings.goalMuscleGain: 'Muscle Building & Lean Bulk',
      AppStrings.goalMaintain: 'Maintain Weight & Fitness',
      AppStrings.goalHealthyLifestyle: 'Healthy Lifestyle & Wellbeing',
      AppStrings.alreadyHaveAccount: 'Already have an account?',
      AppStrings.demoAccountsNotice: 'Tap to quickly fill demo account credentials:',
      AppStrings.loginAsClinic: 'Demo Clinic Customer (In-person)',
      AppStrings.loginAsOnline: 'Demo Online Customer (App subscribed)',
      AppStrings.clinicCustomer: 'Clinic Customer',
      AppStrings.onlineCustomer: 'Online Customer',

      // Tabs
      AppStrings.tabHome: 'Home',
      AppStrings.tabPlan: 'Nutrition',
      AppStrings.tabProgress: 'Progress',
      AppStrings.tabMessages: 'Specialist',
      AppStrings.tabProfile: 'Profile',

      // Home
      AppStrings.welcomeBack: 'Welcome back',
      AppStrings.subscriptionStatus: 'Subscription',
      AppStrings.remainingDays: 'Remaining',
      AppStrings.daysLeft: 'days left',
      AppStrings.dailyCalorieTarget: 'Calorie Target',
      AppStrings.caloriesConsumed: 'Consumed',
      AppStrings.kcal: 'kcal',
      AppStrings.todayMeals: "Today's Meals",
      AppStrings.mealCompletion: 'Daily Meal Completion',
      AppStrings.latestWeight: 'Current Weight',
      AppStrings.latestProgress: 'Latest Progress',
      AppStrings.quickActions: 'Quick Shortcuts',
      AppStrings.viewPlan: 'View Plan',
      AppStrings.trackWeight: 'Log Weight',
      AppStrings.inbodyReports: 'InBody Reports',
      AppStrings.chatWithSpecialist: 'Chat Specialist',
      AppStrings.onlineFollowup: 'Online Follow-up',
      AppStrings.renewSubscription: 'Manage Subscriptions',

      // Plan
      AppStrings.nutritionPlanTitle: 'My Nutrition Plan',
      AppStrings.currentPlan: 'Current Nutrition Protocol',
      AppStrings.planDuration: 'Plan Duration',
      AppStrings.macroNutrients: 'Macro Balance',
      AppStrings.protein: 'Protein',
      AppStrings.carbs: 'Carbs',
      AppStrings.fats: 'Fats',
      AppStrings.grams: 'g',
      AppStrings.breakfast: 'Breakfast',
      AppStrings.lunch: 'Lunch',
      AppStrings.dinner: 'Dinner',
      AppStrings.snack: 'Snack',
      AppStrings.markCompleted: 'Mark as eaten',
      AppStrings.markIncomplete: 'Mark as skipped',
      AppStrings.mealNotes: 'Meal notes',
      AppStrings.addNotes: 'Add notes for this meal...',
      AppStrings.foodItems: 'Included Food Items',
      AppStrings.instructions: 'Specialist Instructions',

      // Progress
      AppStrings.progressDashboard: 'Progress & Biometrics',
      AppStrings.startingWeight: 'Starting',
      AppStrings.weightDifference: 'Difference',
      AppStrings.addWeight: 'Record New Weight',
      AppStrings.weightHistory: 'Weight History Log',
      AppStrings.inbodyTitle: 'InBody Body Composition',
      AppStrings.bodyFatPercentage: 'Body Fat',
      AppStrings.muscleMass: 'Muscle Mass',
      AppStrings.bmi: 'BMI',
      AppStrings.visceralFat: 'Visceral Fat',
      AppStrings.uploadInbody: 'Upload InBody Scan',
      AppStrings.visitHistory: 'Clinic Visit Records',
      AppStrings.visitNotes: 'Visit Summary & Assessment',
      AppStrings.specialistNotes: 'Specialist Notes',

      // Chat
      AppStrings.communicationTitle: 'Nutrition Specialist',
      AppStrings.nutritionSpecialist: 'Dr. Sarah Mansour (Clinical Nutritionist)',
      AppStrings.typeMessage: 'Type your question or update...',
      AppStrings.send: 'Send',
      AppStrings.online: 'Active now',
      AppStrings.offline: 'Away',
      AppStrings.simulatedNotice: 'Demo simulated chat with auto-reply assistant',

      // Subscription
      AppStrings.subscriptionsTitle: 'Subscriptions & Packages',
      AppStrings.availablePackages: 'Select Your Nutrition Package',
      AppStrings.currentSubscriptionDetails: 'Active Plan Details',
      AppStrings.subscribeNow: 'Subscribe Now',
      AppStrings.bankTransferInfo: 'Official Clinic Bank Transfer Details',
      AppStrings.bankName: 'Bank Name: National Healthcare Bank',
      AppStrings.accountNumber: 'Account Number: 9876-5432-1098-7654',
      AppStrings.iban: 'IBAN: EG450000000098765432109876',
      AppStrings.accountHolder: 'Beneficiary: Specialized Nutrition Clinics Center',
      AppStrings.uploadProof: 'Upload Payment Receipt Screenshot',
      AppStrings.submitPayment: 'Submit Payment for Approval',
      AppStrings.paymentPendingReview: 'Payment Pending Administrative Verification',
      AppStrings.paymentPendingDesc: 'Your bank transfer slip has been received. Our clinic management will verify and activate your membership shortly.',
      AppStrings.paymentStatus: 'Payment Status',
      AppStrings.demoPriceNotice: 'All prices shown are simulated demo rates.',

      // Follow-up
      AppStrings.newFollowup: 'Submit Online Check-in',
      AppStrings.followupHistory: 'Check-in Submissions',
      AppStrings.bodyMeasurements: 'Body Circumference (cm)',
      AppStrings.chest: 'Chest',
      AppStrings.waist: 'Waist',
      AppStrings.hips: 'Hips',
      AppStrings.uploadMedicalTests: 'Attach Lab Blood Work / Tests (PDF/Image)',
      AppStrings.uploadProgressPhotos: 'Attach Front/Side Progress Photos',
      AppStrings.notesForSpecialist: 'Notes, cravings, energy levels, or questions for your doctor',
      AppStrings.statusSubmitted: 'Submitted',
      AppStrings.statusUnderReview: 'Under Review',
      AppStrings.statusReviewed: 'Reviewed & Updated',
      AppStrings.statusNeedInfo: 'Requires Additional Info',

      // Notifications
      AppStrings.notificationsTitle: 'Notification Center',
      AppStrings.markAllRead: 'Mark all as read',
      AppStrings.noNotifications: 'You have no notifications yet',

      // Profile
      AppStrings.profileTitle: 'Profile & Account',
      AppStrings.editProfile: 'Edit Personal Profile',
      AppStrings.settings: 'App Settings & Preferences',
      AppStrings.language: 'Language / اللغة',
      AppStrings.english: 'English',
      AppStrings.arabic: 'العربية (Arabic)',
      AppStrings.notificationsEnabled: 'Push Notifications',
      AppStrings.changePassword: 'Change Password',
      AppStrings.logout: 'Log Out',
      AppStrings.logoutConfirm: 'Are you sure you want to log out?',
      AppStrings.version: 'Demo Version 1.0.0 (Clean Architecture)',

      // Validation
      AppStrings.requiredField: 'This field is required',
      AppStrings.invalidEmail: 'Please enter a valid email address',
      AppStrings.passwordTooShort: 'Password must be at least 6 characters',
    },
    'ar': {
      AppStrings.appName: 'عيادة التغذية والأنظمة الغذائية',
      AppStrings.cancel: 'إلغاء',
      AppStrings.confirm: 'تأكيد',
      AppStrings.save: 'حفظ',
      AppStrings.submit: 'إرسال',
      AppStrings.delete: 'حذف',
      AppStrings.retry: 'إعادة المحاولة',
      AppStrings.back: 'رجوع',
      AppStrings.next: 'التالي',
      AppStrings.loading: 'جاري التحميل...',
      AppStrings.success: 'تم بنجاح',
      AppStrings.error: 'حدث خطأ ما',
      AppStrings.viewAll: 'عرض الكل',
      AppStrings.details: 'التفاصيل',
      AppStrings.date: 'التاريخ',
      AppStrings.status: 'الحالة',
      AppStrings.active: 'نشط',
      AppStrings.inactive: 'غير نشط',
      AppStrings.pending: 'قيد الانتظار',
      AppStrings.demoMode: 'لوحة التحكم التجريبية',
      AppStrings.demoTestingTools: 'أدوات الاختبار والمحاكاة',

      // Auth
      AppStrings.loginTitle: 'مرحباً بك مجدداً',
      AppStrings.loginSubtitle: 'سجل دخولك لمتابعة خطتك الغذائية ومؤشرات تقدمك',
      AppStrings.emailOrPhone: 'البريد الإلكتروني أو رقم الهاتف',
      AppStrings.password: 'كلمة المرور',
      AppStrings.rememberMe: 'تذكرني',
      AppStrings.forgotPassword: 'نسيت كلمة المرور؟',
      AppStrings.forgotPasswordTitle: 'استعادة كلمة المرور',
      AppStrings.forgotPasswordDesc: 'أدخل بريدك الإلكتروني لاستلام تعليمات إعادة التعيين',
      AppStrings.sendResetLink: 'إرسال رابط الاستعادة',
      AppStrings.resetLinkSent: 'تم إرسال رابط الاستعادة إلى بريدك (محاكاة)',
      AppStrings.login: 'تسجيل الدخول',
      AppStrings.donotHaveAccount: 'ليس لديك حساب؟',
      AppStrings.createAccount: 'إنشاء حساب أونلاين',
      AppStrings.registerTitle: 'تسجيل مشترك أونلاين جديد',
      AppStrings.registerSubtitle: 'ابدأ رحلتك نحو نمط حياة صحي ورشيق اليوم',
      AppStrings.fullName: 'الاسم بالكامل',
      AppStrings.email: 'البريد الإلكتروني',
      AppStrings.phone: 'رقم الهاتف',
      AppStrings.gender: 'الجنس',
      AppStrings.male: 'ذكر',
      AppStrings.female: 'أنثى',
      AppStrings.age: 'العمر (بالسنوات)',
      AppStrings.height: 'الطول (سم)',
      AppStrings.currentWeight: 'الوزن الحالي (كجم)',
      AppStrings.targetWeight: 'الوزن المستهدف (كجم)',
      AppStrings.mainGoal: 'الهدف الرئيسي',
      AppStrings.goalWeightLoss: 'خسارة الوزن وحرق الدهون',
      AppStrings.goalMuscleGain: 'بناء العضلات وزيادة الكتلة العضلية',
      AppStrings.goalMaintain: 'تثبيت الوزن وتحسين اللياقة',
      AppStrings.goalHealthyLifestyle: 'نمط حياة صحي وتغذية علاجية',
      AppStrings.alreadyHaveAccount: 'لديك حساب بالفعل؟',
      AppStrings.demoAccountsNotice: 'اضغط لتعبئة بيانات الحساب التجريبي بسرعة:',
      AppStrings.loginAsClinic: 'عميل عيادة (متابع في المقر)',
      AppStrings.loginAsOnline: 'عميل أونلاين (مشترك عبر التطبيق)',
      AppStrings.clinicCustomer: 'عميل عيادة',
      AppStrings.onlineCustomer: 'عميل أونلاين',

      // Tabs
      AppStrings.tabHome: 'الرئيسية',
      AppStrings.tabPlan: 'النظام الغذائي',
      AppStrings.tabProgress: 'التقدم',
      AppStrings.tabMessages: 'المختص',
      AppStrings.tabProfile: 'حسابي',

      // Home
      AppStrings.welcomeBack: 'أهلاً بك',
      AppStrings.subscriptionStatus: 'الاشتراك',
      AppStrings.remainingDays: 'المتبقي',
      AppStrings.daysLeft: 'يوم متبقي',
      AppStrings.dailyCalorieTarget: 'هدف السعرات اليومية',
      AppStrings.caloriesConsumed: 'المستهلك',
      AppStrings.kcal: 'سعرة',
      AppStrings.todayMeals: 'وجبات اليوم',
      AppStrings.mealCompletion: 'نسبة إنجاز الوجبات',
      AppStrings.latestWeight: 'آخر وزن مسجل',
      AppStrings.latestProgress: 'مؤشر التقدم',
      AppStrings.quickActions: 'الوصول السريع',
      AppStrings.viewPlan: 'الخطة الغذائية',
      AppStrings.trackWeight: 'تسجيل وزن',
      AppStrings.inbodyReports: 'تقارير InBody',
      AppStrings.chatWithSpecialist: 'محادثة المختص',
      AppStrings.onlineFollowup: 'المتابعة الدورية',
      AppStrings.renewSubscription: 'الباقات والاشتراكات',

      // Plan
      AppStrings.nutritionPlanTitle: 'نظامي الغذائي',
      AppStrings.currentPlan: 'الخطة التغذوية الحالية',
      AppStrings.planDuration: 'مدة الخطة',
      AppStrings.macroNutrients: 'توزيع العناصر الغذائية',
      AppStrings.protein: 'بروتين',
      AppStrings.carbs: 'كاربوهيدرات',
      AppStrings.fats: 'دهون صحية',
      AppStrings.grams: 'جرام',
      AppStrings.breakfast: 'الإفطار',
      AppStrings.lunch: 'الغداء',
      AppStrings.dinner: 'العشاء',
      AppStrings.snack: 'سناك خفيف',
      AppStrings.markCompleted: 'تم تناول الوجبة',
      AppStrings.markIncomplete: 'إلغاء التناول',
      AppStrings.mealNotes: 'ملاحظات الوجبة',
      AppStrings.addNotes: 'أضف ملاحظاتك أو بدائل الأطعمة...',
      AppStrings.foodItems: 'مكونات الوجبة',
      AppStrings.instructions: 'تعليمات أخصائي التغذية',

      // Progress
      AppStrings.progressDashboard: 'مؤشرات القياس والتقدم',
      AppStrings.startingWeight: 'وزن البداية',
      AppStrings.weightDifference: 'إجمالي التغير',
      AppStrings.addWeight: 'تسجيل قياس جديد',
      AppStrings.weightHistory: 'سجل الأوزان',
      AppStrings.inbodyTitle: 'تقارير تكوين الجسم (InBody)',
      AppStrings.bodyFatPercentage: 'نسبة الدهون',
      AppStrings.muscleMass: 'الكتلة العضلية',
      AppStrings.bmi: 'كتلة الجسم (BMI)',
      AppStrings.visceralFat: 'الدهون الحشوية',
      AppStrings.uploadInbody: 'رفع تقرير InBody جديد',
      AppStrings.visitHistory: 'سجل زيارات العيادة',
      AppStrings.visitNotes: 'ملخص جلسة الكشف',
      AppStrings.specialistNotes: 'ملاحظات الأخصائي',

      // Chat
      AppStrings.communicationTitle: 'التواصل مع الأخصائي',
      AppStrings.nutritionSpecialist: 'د. سارة منصور (أخصائية التغذية العلاجية)',
      AppStrings.typeMessage: 'اكتب استفسارك أو تحديثاتك هنا...',
      AppStrings.send: 'إرسال',
      AppStrings.online: 'متواجد الآن',
      AppStrings.offline: 'غير متصل',
      AppStrings.simulatedNotice: 'محادثة تجريبية تحاكي الردود التلقائية والذكية للمختص',

      // Subscription
      AppStrings.subscriptionsTitle: 'الباقات والاشتراكات',
      AppStrings.availablePackages: 'اختر باقة التغذية المناسبة لك',
      AppStrings.currentSubscriptionDetails: 'تفاصيل الاشتراك الحالي',
      AppStrings.subscribeNow: 'اشترك الآن',
      AppStrings.bankTransferInfo: 'بيانات التحويل البنكي لحساب العيادة',
      AppStrings.bankName: 'اسم البنك: بنك الرعاية والتنمية',
      AppStrings.accountNumber: 'رقم الحساب: 9876-5432-1098-7654',
      AppStrings.iban: 'الآيبان: EG450000000098765432109876',
      AppStrings.accountHolder: 'اسم المستفيد: مركز عيادات التغذية المتخصصة',
      AppStrings.uploadProof: 'رفع إيصال التحويل البنكي',
      AppStrings.submitPayment: 'إرسال الإيصال للمراجعة والتفعيل',
      AppStrings.paymentPendingReview: 'طلب الاشتراك قيد مراجعة الإدارة',
      AppStrings.paymentPendingDesc: 'تم استلام إشعار التحويل البنكي بنجاح. سيقوم فريق إدارة العيادة بالتحقق وتفعيل اشتراكك.',
      AppStrings.paymentStatus: 'حالة الدفع',
      AppStrings.demoPriceNotice: 'الأسعار المعروضة هي أسعار تجريبية للاختبار.',

      // Follow-up
      AppStrings.newFollowup: 'إرسال المتابعة الدورية',
      AppStrings.followupHistory: 'سجل المتابعات الدورية',
      AppStrings.bodyMeasurements: 'محيطات ومقاسات الجسم (سم)',
      AppStrings.chest: 'الصدر',
      AppStrings.waist: 'الخصر',
      AppStrings.hips: 'الأرداف',
      AppStrings.uploadMedicalTests: 'إرفاق التحاليل والفحوصات الطبية',
      AppStrings.uploadProgressPhotos: 'إرفاق صور التطور (أمامي / جانبي)',
      AppStrings.notesForSpecialist: 'ملاحظاتك ومستوى الطاقة والالتزام خلال الفترة',
      AppStrings.statusSubmitted: 'تم الإرسال',
      AppStrings.statusUnderReview: 'قيد مراجعة الطبيب',
      AppStrings.statusReviewed: 'تمت المراجعة وتعديل الخطة',
      AppStrings.statusNeedInfo: 'مطلوب استكمال بيانات',

      // Notifications
      AppStrings.notificationsTitle: 'مركز التنبيهات والإشعارات',
      AppStrings.markAllRead: 'تحديد الكل كمقروء',
      AppStrings.noNotifications: 'لا توجد إشعارات جديدة حالياً',

      // Profile
      AppStrings.profileTitle: 'الملف الشخصي والحساب',
      AppStrings.editProfile: 'تعديل البيانات الشخصية',
      AppStrings.settings: 'إعدادات التطبيق',
      AppStrings.language: 'لغة التطبيق / Language',
      AppStrings.english: 'English (الإنجليزية)',
      AppStrings.arabic: 'العربية',
      AppStrings.notificationsEnabled: 'تفعيل الإشعارات',
      AppStrings.changePassword: 'تغيير كلمة المرور',
      AppStrings.logout: 'تسجيل الخروج',
      AppStrings.logoutConfirm: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
      AppStrings.version: 'النسخة التجريبية 1.0.0 (Clean Architecture)',

      // Validation
      AppStrings.requiredField: 'هذا الحقل مطلوب',
      AppStrings.invalidEmail: 'يرجى إدخال بريد إلكتروني صحيح',
      AppStrings.passwordTooShort: 'كلمة المرور يجب ألا تقل عن 6 أحرف',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
