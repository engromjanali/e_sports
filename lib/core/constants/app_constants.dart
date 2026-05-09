
class AppConstants {
  static const String appName = 'e-sports';
  static const String appVersion = '1.0.0'; ///Flutter sdk 3.41.7

  static const String fontFamily = 'Roboto';
  static const bool payInWevView = false;
  static const int balanceInputLen = 10;
  static const String webHostedUrl = 'https://6ammart-test-web.6amdev.xyz';

  static const bool useReactWebsite = false;
  static const bool stopPolylineAnimation = false;
  static const String googleServerClientId = '491987943015-agln6biv84krpnngdphj87jkko7r9lb8.apps.googleusercontent.com';
  static const String pusherBroadcustUrl = '/api/v1/broadcasting/user-auth';

  static const String baseUrl = 'https://foatball.vercel.app';

  /// auth endpoints
  static const String configUri = "/api/user/config";
  static const String registationUri = "/api/user/registation";
  static const String loginUri = "/api/user/signin";
  static const String forgetPaasswordUri = "/api/user/forget-password";
  static const String profileUri = "/api/user/profile";

  // static List<ChooseUsModel> whyChooseUsList = [
  //   ChooseUsModel(icon: Images.landingTrusted, title: 'trusted_by_customers_and_store_owners'),
  //   ChooseUsModel(icon: Images.landingStores, title: 'thousands_of_stores'),
  //   ChooseUsModel(icon: Images.landingExcellent, title: 'excellent_shopping_experience'),
  //   ChooseUsModel(icon: Images.landingCheckout, title: 'easy_checkout_and_payment_system'),
  // ];


  // static List<LanguageModel> languages = [
  //   LanguageModel(imageUrl: Images.english, languageName: 'English', countryCode: 'US', languageCode: 'en'),
  //   LanguageModel(imageUrl: Images.arabic, languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
  //   LanguageModel(imageUrl: Images.spanish, languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  //   LanguageModel(imageUrl: Images.bengali, languageName: 'Bengali', countryCode: 'BN', languageCode: 'bn'),
  // ];

  static List<String> joinDropdown = [
    'join_us',
    'become_a_seller',
    'become_a_delivery_man',
    'join_as_a_rider',
  ];

  // keys
  static const token = 'token';

  ///Rental Type
  static const String hourly = 'hourly';
  static const String distanceWise = 'distance_wise';
  static const String dayWise = 'day_wise';
}
